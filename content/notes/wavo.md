---
title: "wavo: a music processing AI agent on Telegram"
date: 2026-09-08 08:00:00
tags:
- ai
- rust
- music
- open-source
---

[wavo](https://github.com/pwittchen/wavo) is an AI agent for music processing. You send it a plain-language message on Telegram - *"separate vocals from Queen - Bohemian Rhapsody"*, *"slow that song down to 80%"*, or just a YouTube link with a note about what to do with it - and it works out which audio operations that means, runs them, publishes the result and replies with a link.

It's written in Rust, it's one binary, and it glues together two other projects of mine: [demix](https://github.com/pwittchen/demix) does the actual audio work (stem separation, tempo, pitch, key detection, cutting) and [plainsong](https://github.com/pwittchen/plainsong) stores the results.

```
Telegram ──long poll──▶ wavo ──stdio──▶ demix-mcp ──▶ demix (spleeter, ffmpeg, yt-dlp)
                         │                            │ downloads only
                         │                            └──▶ optional proxy ──▶ YouTube
                         ├──HTTP──▶ an OpenAI-compatible chat completions API
                         └──HTTP──▶ plainsong  ──▶  your music collection
```

No database, no queue, no web UI of its own, no user accounts. The only authentication is an allow-list of Telegram chat IDs - the bot stays silent for everyone else and logs the rejected ID, which is a convenient way to find out your own.

## What it looks like in use

```
you   https://youtu.be/fJ9rUzIMcZQ slow it down to 80% and give me just the vocals
wavo  ⏳ Thinking…
      ⏳ downloading… (0:04)
      ⏳ separating stems… (1:12)
      Here are the vocals at 80% speed.

      ✅ Bohemian Rhapsody — vocals (0.8×)
      🎵 https://music.example.com/track.html?id=7f1c…
      📚 all songs: https://music.example.com/
```

wavo understands both English and Polish, and replies in whichever language you wrote in - including the modification name it writes into the track title.

Commands (`/status`, `/tracks`, `/reset`, `/cancel`) are answered by wavo itself without involving the model.

## Why an MCP client and not a wrapper

demix already ships an MCP server (`demix-mcp`), so wavo doesn't reimplement any audio knowledge. It spawns the server as a child process over stdio, discovers the tools at startup, and converts their JSON Schemas into OpenAI function definitions. The conversion is nearly mechanical - a rename - with one substantive edit:

```rust
/// Arguments the model never gets to choose. demix resolves output paths
/// relative to `cwd`, so both have to go.
pub const INJECTED_ARGS: [&str; 2] = ["cwd", "output_dir"];
```

Both are stripped from `properties` and from `required` before the schema reaches the model, and filled in by wavo per job. Adding a tool to demix makes it available in wavo with no code change on this side.

## Three rules that shape the code

Most of the interesting design in wavo is about what the model is *not* allowed to decide.

**The model never picks a path.** Beyond the stripped schema arguments, `publish_track` accepts only keys from the current turn's path table - the names wavo itself put into previous tool results. A constructed path, a plausible sibling of a real output, `/etc/passwd`: all refused before the file is opened. The containment check runs on the canonical path, so a symlink pointing out of the job directory is refused too.

**Tool failures are results, not errors.** A failed demix run comes back to the model as `{"ok": false, "error": "…"}` so it can correct itself, with the full stderr in the log and a classified, human sentence for the user. The same applies to malformed tool calls; after two invalid ones wavo escalates to a stronger fallback model (`OPENAI_MODEL_FALLBACK`, `gpt-5` by default), and abandons the turn if that doesn't help either.

**wavo composes its own links and its own titles.** The track link and the listing link are appended by wavo after the model's reply, so a hallucinated URL can't reach a user. Titles work the same way: `publish_track` takes `artist`, `title` and `modification` as three separate arguments and wavo joins them into `Artist — Title (modification)`. A part the model omitted gets a localized placeholder rather than failing an upload of a file that already exists.

For a bare link there is nothing to compose from, so after the run wavo asks yt-dlp what the video is called and hands the answer to the model as a fact to split - performer here, song there, "Official Video Remastered" dropped - instead of as a ready-made title.

## Half a request

The thing I didn't expect to need is message coalescing. People don't send one tidy message; they paste a link and then, a few seconds later, say what to do with it. Or the other way round.

So every incoming message is classified: does it name something to work on (a link, a song title, or the song already under discussion) *and* say what to do with it? If yes, the turn starts immediately. If not, the message goes into a per-chat buffer and waits about 15 seconds for its other half, in either order:

```
you   https://youtu.be/fJ9rUzIMcZQ
you   remove the vocals              ← wavo starts here, on both messages at once
```

The two are joined with a newline and handed to the model as one request. If the other half never arrives, wavo runs what it has when the window closes: a lone link gets converted with the defaults, a lone instruction gets a clarifying question.

The classifier is deliberately dumb - a bilingual word list of actions and stems, with URLs excised first so their tokens don't read as song names, and numbers never counting as names. It only decides *when to start*, and the model still gets the raw text, so a wrong guess costs a 15-second wait, not a wrong answer.

## Progress that doesn't lie

`demix-mcp` runs demix to completion and returns everything at once, so there is no progress stream to read. Instead of inventing percentages, wavo reports what it *asked demix to do*: `downloading` while a remote source is being fetched, `separating stems` / `applying effects` after a minute, `uploading` when publishing - plus an elapsed time that ticks. The stage transition is an estimate; the elapsed time isn't.

It all happens by editing the acknowledgement message in place, rate limited to one edit every five seconds because Telegram answers a burst of edits with a 429 and then ignores the bot for a while. The same message eventually becomes the final answer.

## Deployment, and the part that will bite you

Both images are published to ghcr.io, so a deployment is two files - the compose file and an `.env` - and `docker compose up -d`. Nothing to clone, no toolchain on the server, no inbound port, since Telegram is long-polled outbound. `restart: unless-stopped` is the whole supervision story.

Two operational facts are worth knowing before you pick a machine.

**RAM, not CPU, is the constraint.** Spleeter loads the whole track as float32 and holds a complex STFT plus one mask per stem, so peak memory grows linearly with track length *and* stem count:

| track length | `2stems` | `4stems` |
|--------------|----------|----------|
| 4 min | 4.45 GB | 7.41 GB |
| 8 min | 7.86 GB | 11.72 GB |
| 10 min | 10.34 GB | 14.08 GB |

That's measured peak RSS. 8 GB is enough for 2-stem work, 16 GB if 4 stems should always succeed. Speed is not the issue - a 4-minute 2-stem separation takes about 13 seconds - but exceeding RAM without swap is an instant OOM kill.

**amd64 only.** essentia, which demix uses for key detection, has never published a `linux/aarch64` wheel. On Apple Silicon the image runs under Rosetta; an arm64 VPS is not a realistic option.

And when YouTube starts asking to *"sign in to confirm you're not a bot"*, it's almost always one of two things: a stale yt-dlp (pinned in the Dockerfile precisely so the build cache can't keep shipping an old one), or a datacenter IP. For the second one wavo can route downloads - and only downloads; Telegram, the LLM and plainsong still go direct - through a residential proxy set with five environment variables. It probes the proxy at startup and names it in the log with the password redacted.

## Testing

Everything runs offline. The OpenAI and plainsong clients are tested against a stub HTTP server, and the MCP layer against a ~100-line Python MCP server in `tests/fixtures/` that also knows how to die mid-call, so the child-process restart policy gets exercised. No test touches the real OpenAI API, the real Telegram API or YouTube. The one end-to-end test that needs a real demix install and a running plainsong is `#[ignore]`d.

```sh
cargo test
cargo clippy --all-targets -- -D warnings
```

## Links

- source code: [github.com/pwittchen/wavo](https://github.com/pwittchen/wavo)
- the audio engine: [github.com/pwittchen/demix](https://github.com/pwittchen/demix)
- the storage: [github.com/pwittchen/plainsong](https://github.com/pwittchen/plainsong)

The design is written down in [SPEC.md](https://github.com/pwittchen/wavo/blob/master/SPEC.md), including a section on where the implementation deviates from it and why. Released under the Apache 2.0 license.
