---
title: "moodbeat: a music player creating playlists from your mood"
date: 2026-09-29
tags:
- rust
- tauri
- music
- ai
- open-source
---

<img src="/posts/2026/moodbeat/moodbeat_logo.png" alt="moodbeat logo" width="180" style="border: none;">

[moodbeat](https://github.com/pwittchen/moodbeat) is a desktop music player that builds a playlist from a mood you describe. You type something like *"90s rock"*, *"rainy day in New York"* or *"Polish summertime"*, and moodbeat asks OpenAI for 10-15 matching songs, finds them on YouTube, downloads them as MP3 and plays them in order.

I often know *what kind* of music I want to hear, but not *which songs*. Streaming services have mood playlists, but they're curated for everybody, and describing a vibe in my own words is much faster than scrolling through them. LLMs turned out to be surprisingly good music curators, so I built a small player around that idea.

<img src="/posts/2026/moodbeat/moodbeat_screenshot_playlist.png" alt="moodbeat playing a rain-soaked city noir playlist" width="400" style="border: none;">

## One screen

The app is deliberately small: one input, one list, one player bar and a settings panel behind the gear icon. The UI is dark and Spotify-inspired - no sidebar, no library, no album art.

After pressing *Generate*, the whole playlist shows up right away, and each row updates its status live: `pending → searching → downloading (n%) → ready`. Playback starts as soon as the first track is ready, not when all of them are, so the time from typing a mood to hearing music is as short as possible. If the next track is still downloading when the current one ends, the player waits for it, and tracks that couldn't be found are skipped (with a retry option on hover).

The player itself is what you'd expect: play/pause, previous, next, seeking and volume, plus keyboard shortcuts (`Space`, arrows, `M` for mute).

## From a mood to a playlist

The mood is sent to the OpenAI Responses API with Structured Outputs, so the answer is always valid JSON matching a schema: a short playlist title and 10-15 songs with artist, title and year. The system prompt asks for real, well-known songs, mixed artists (max 2 songs per artist) and an order that flows well. Temperature is moderate, so the same mood gives some variety between runs. The model can be picked in Settings - a small, cheap one is the default and works fine for this task.

The response is cleaned up on the Rust side: entries with empty fields and duplicates are dropped, and if fewer than 5 songs survive, you get a friendly error asking to describe the mood differently.

## From a song to an MP3

Finding and downloading songs is done by [yt-dlp](https://github.com/yt-dlp/yt-dlp) and [ffmpeg](https://ffmpeg.org/). Pure-Rust YouTube crates break too often to rely on them, while yt-dlp tracks YouTube changes and is updated all the time. If the tools aren't on your `PATH`, moodbeat downloads them into `~/.moodbeat/bin/` on the first launch and keeps yt-dlp up to date.

For each song, moodbeat searches YouTube for the top 5 results and picks the best one with a simple scoring function. It prefers results with the artist and title in the name, official artist channels (`<Artist> - Topic`, `VEVO`) and "official audio/video", and penalizes live versions, covers, karaoke, remixes, "slowed", "sped up", "nightcore" and so on - unless you actually asked for them. Very short and very long videos are dropped.

Downloads run in playlist order, max 3 at a time, so the first tracks are ready first. Clicking a track that is still pending moves it to the front of the queue. Everything is cached by YouTube video id, and a small index maps songs to video ids, so songs that show up in another playlist play immediately, without searching or downloading. The cache is limited to 2 GB by default and evicts the least recently played files.

## Under the hood

moodbeat is a Tauri 2 app. The backend in `core/` is Rust with `tokio` and `reqwest`, split into small modules: config, the OpenAI client, the YouTube resolver, the downloader with progress parsing and cancellation, the cache, playlists and managing external tools. Rust owns all network I/O, process spawning, file system access and secrets - the API key never reaches the frontend.

The frontend in `ui/` is plain TypeScript with Vite and no framework. Audio is played by a regular HTML5 `<audio>` element pointing at the local MP3 file. It gives play/pause, seeking, duration and the `ended` event for free, and keeps the whole player state in one place. MP3 was chosen as the output format because it plays in every WebView Tauri uses (WKWebView, WebView2 and WebKitGTK with GStreamer).

All the app data - settings, audio cache, playlists and logs - lives in `~/.moodbeat/`.

Before writing any code, I wrote a [SPEC.md](https://github.com/pwittchen/moodbeat/blob/master/SPEC.md) and a [DESIGN.md](https://github.com/pwittchen/moodbeat/blob/master/DESIGN.md) describing the behavior, architecture and visual design in detail. CI runs the frontend and backend tests together with clippy in pedantic mode.

## Download

Releases are built by GitHub Actions after pushing a version tag and published on [GitHub Releases](https://github.com/pwittchen/moodbeat/releases/latest):

- **macOS (Apple Silicon)** - a signed and notarized `.dmg`
- **Linux x86_64 and aarch64** - `.AppImage`, `.deb` and `.rpm`

On the first launch, enter your OpenAI API key in Settings and type your first mood.

## Legal note

Downloading from YouTube may conflict with YouTube's Terms of Service and with copyright law in some countries. moodbeat is meant for personal use only and intentionally provides no way to export or share the downloaded files.

## Links

- source code: [github.com/pwittchen/moodbeat](https://github.com/pwittchen/moodbeat)
- releases: [github.com/pwittchen/moodbeat/releases](https://github.com/pwittchen/moodbeat/releases)
- design: [SPEC.md](https://github.com/pwittchen/moodbeat/blob/master/SPEC.md) and [DESIGN.md](https://github.com/pwittchen/moodbeat/blob/master/DESIGN.md)

Released under the GPL-3.0 license.
