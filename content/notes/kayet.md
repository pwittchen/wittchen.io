---
title: "kayet: a minimalistic text editor for macOS"
date: 2026-09-28
tags:
- rust
- tauri
- macos
- markdown
- open-source
---

<img src="/posts/2026/kayet/kayet_logo.png" alt="kayet logo" width="180" style="border: none;">

[kayet](https://github.com/pwittchen/kayet) is a minimalistic text editor for macOS, written in Rust with Tauri. When you're writing, the only thing on screen is your text. The title bar, the controls and the file tree show up only when you reach for them with the mouse, and then fade away again.

I write a lot of notes and drafts in Markdown - including the posts on this blog - and I wanted a place for that which is quiet. Most editors are built around code: gutters, tabs, status bars, panels, minimaps. Even the "distraction-free" modes usually feel like a mode bolted onto a busy app. I wanted the opposite: an app that is empty by default and adds things only when asked.

Website: [getkayet.app](https://getkayet.app).

<img src="/posts/2026/kayet/kayet_screenshot.png" alt="kayet screenshot" style="border: none;">

## Hidden chrome

A fresh kayet window shows only the editor. No title bar, no traffic lights, no sidebar, no preview. Moving the mouse into the top ~40px of the window reveals the title bar with the document name and a row of small, monochrome icons; moving it away fades everything out again after a moment. Typing hides it immediately.

```
┌───────────────────────────────────────────────────────────────────┐
│ ● ● ●            filename.md — edited            [⌂] [▤] [◐] [◉]  │  ← title bar (hover only)
├──────────────┬─────────────────────────────┬──────────────────────┤
│ workspace    │                             │                      │
│  ▸ notes     │   Editor                    │   Markdown preview   │
│  ▾ drafts    │                             │   (optional)         │
│     a.md     │                             │                      │
│ (optional)   │                             │                      │
└──────────────┴─────────────────────────────┴──────────────────────┘
```

The design language is "macOS-native + Linear": generous whitespace, a soft neutral palette, 1px hairline borders, restrained motion and no unnecessary icons or labels. Light and dark themes follow the system appearance by default.

## Writing Markdown

Markdown is the main use case, so it gets a bit of extra care, without any UI of its own:

- `Enter` continues bullet, numbered and task lists and block quotes, `Backspace` after a marker removes it
- `⌘B` / `⌘I` toggle bold and italic
- pasting a URL over selected text turns it into a link
- pasting an image saves it next to the file and inserts `![](…)` pointing to it
- the title bar shows a word count and reading time for prose

The live preview (`⌘⇧P`) opens in a split pane on the right, with approximate scroll sync. It's rendered on the Rust side with `pulldown-cmark` (CommonMark plus GFM tables, task lists, strikethrough and footnotes) and sanitized with `ammonia`, so no scripts ever run in the preview. A document can also be exported as a self-contained HTML page (images embedded as `data:` URIs) or as a PDF.

There's also a Zen mode (`⌘⇧J`), which keeps the cursor line vertically centered and dims everything except the current paragraph.

## Not only prose

Although kayet is aimed at writing, it's also handy for a quick look at a config file or a script. Source code and data files get syntax highlighting picked by file extension, with grammars loaded lazily per language. A "code editor mode" switches the layout to what you'd expect from a code editor: line numbers, monospace font, no soft wrap and no readable column.

Other things you'd expect from an editor are there too, but out of the way:

- tabs, each with its own undo history and scroll position
- a command palette (`⌘K`), a fuzzy file finder (`⌘P`) and workspace-wide search (`⌘⇧F`)
- Firefox-style find and replace docked at the bottom
- a file tree for the workspace (`⌘\`), updated live when files change on disk
- crash recovery for unsaved changes
- automatic updates from GitHub Releases

## Workspace and the terminal

kayet works on a workspace directory, which is `~/.kayet/workspace/` by default. It can be changed at any time and is remembered across restarts. Configuration lives in a single `~/.kayet/config.toml`, which can be opened in kayet itself (`⌘,`) - saving it applies the changes immediately.

After installing the shell command (from the app menu or the command palette), files and folders can be opened straight from the terminal:

```sh
kayet notes.md     # open a file (created if missing)
kayet .            # use the current folder as the workspace
```

`.md` and `.txt` files can also be opened from Finder via **Open With → kayet**.

## Under the hood

kayet is a Tauri 2 app. The backend in `core/` is Rust: Tauri commands, config, the workspace watcher (`notify`), file operations with atomic writes, workspace search, Markdown rendering, crash recovery and the updater. The frontend in `ui/` is plain TypeScript with CodeMirror 6 - no heavy UI framework.

I had a few performance targets from the beginning, and they're checked by a benchmark script against a real release build:

| Check | Target |
|---|---|
| Cold start to first paint | < 350ms |
| Opening a 5MB file | no UI freeze (longest frame < 100ms) |
| Typing in it | no UI freeze (longest frame < 100ms) |
| Preview render of a ~50KB document | < 16ms |

The benchmark launches the app with an environment variable set, the app measures itself, prints the results and quits, and the script fails when any target is missed. Files over ~10MB open in a "large file mode" without preview, highlighting and word count, because each of these goes over the whole text on every edit.

A small detail I like: the updater doesn't bundle an HTTP client. It uses the system's `curl`, `hdiutil`, `codesign` and `ditto`, and before replacing the running app, it verifies that the downloaded one is signed by the same Developer ID team.

Releases are built by GitHub Actions after pushing a version tag. The workflow signs the app, notarizes it with Apple, packages it into a `.dmg` and publishes it to GitHub Releases with a changelog.

## What it's not

The non-goals are as important as the goals here. kayet has no plugins, no language servers, no autocompletion, no Git integration, no rich-text editing and no cloud sync. It runs on macOS on Apple Silicon only. There are plenty of great editors that do all of that - kayet is meant to be the one you open when you just want to write.

## Links

- website: [getkayet.app](https://getkayet.app)
- source code: [github.com/pwittchen/kayet](https://github.com/pwittchen/kayet)
- design: [SPEC.md](https://github.com/pwittchen/kayet/blob/master/SPEC.md) and [ARCH.md](https://github.com/pwittchen/kayet/blob/master/ARCH.md)

Released under the Apache 2.0 license.
