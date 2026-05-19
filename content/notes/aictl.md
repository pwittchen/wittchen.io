---
title: "Six weeks of agentic coding in Rust: AICTL"
date: 2026-05-19 08:00:00
tags:
- AI
- rust
- CLI
- open-source
---

For the last month and a half I've been working on a new project called [AICTL](https://aictl.app). It's a native AI agent for the terminal and macOS desktop, written in Rust. Source code is available on [GitHub](https://github.com/pwittchen/aictl).

It started mostly out of curiosity. I wanted to see how far I can push agentic software engineering on a real greenfield project - not a toy example or a weekend script, but a complete piece of software with a CLI, a desktop app, a server, documentation, CI, releases and the boring stuff around it. So I picked a domain I actually use every day (AI tooling), set a few constraints (Rust, native, one config, multiple frontends) and started experimenting.

The project itself became my testbed for different agentic workflows - which tasks to delegate, how to structure context, when to let the agent run autonomously, when to keep a tight feedback loop. The result, after several iterations, is a tool I now use daily.

## What it actually is

AICTL has three parts that share the same engine:

- a **CLI** with an interactive REPL and single-shot mode,
- a **macOS desktop app** built with Tauri, with feature parity with the CLI,
- an **HTTP server** (`aictl-server`) which works as an OpenAI-compatible LLM proxy with redaction, audit log, prompt-injection blocking and a master-key gate.

The same config, the same providers, the same tools and agents everywhere. You set it up once and the desktop app and the CLI behave the same way.

```
       ┌────────────┐   ┌────────────┐   ┌────────────┐
       │    CLI     │   │  Desktop   │   │   Server   │
       │  (REPL)    │   │  (Tauri)   │   │   (HTTP)   │
       └─────┬──────┘   └─────┬──────┘   └─────┬──────┘
             │                │                │
             └────────────────┼────────────────┘
                              │
                       ┌──────┴───────┐
                       │  aictl-core  │
                       │  (Rust lib)  │
                       └──────┬───────┘
                              │
       ┌──────────────────────┼──────────────────────┐
       │                      │                      │
   ┌───┴────┐           ┌─────┴─────┐         ┌──────┴──────┐
   │ Cloud  │           │   Local   │         │  Tools /    │
   │ models │           │  models   │         │  agents /   │
   │ APIs   │           │ GGUF/MLX  │         │  skills     │
   └────────┘           └───────────┘         └─────────────┘
```

## Installation

One-liner:

```bash
curl -sSf https://aictl.app/install.sh | sh
```

For the desktop app, there's a `.dmg` on [aictl.app/desktop.html](https://aictl.app/desktop.html) for both Apple Silicon and Intel.

## Basic usage

AICTL is a **BYOK** (Bring Your Own Key) tool - there's no hosted backend, no subscription, no usage cap on my side. You bring your own provider account (OpenAI, Anthropic, Gemini, OpenRouter, Ollama running locally, etc.) and AICTL talks to it directly with your key. Keys are stored on your machine, either in the config file or in the system keychain.

There are three ways to configure it, and all of them produce the same result:

- **Interactive CLI wizard.** Running `aictl --config` (also triggered automatically on first launch) walks you through choosing a provider, picking a model from the supported list and pasting an API key. Good for getting started without reading docs.
- **Desktop app settings.** The macOS app has a regular settings screen with the same options exposed as form fields - dropdowns for provider and model, a password field for the key, toggles for security knobs. The app reads and writes the exact same files as the CLI, so changing something in one is immediately visible in the other.
- **Manual edit of `~/.aictl/config`.** Under the hood it's just a plain text config file. If you prefer to keep your dotfiles under version control, copy-paste a setup between machines or script it, you can edit the file directly. All keys are documented in [`docs/CONFIG.md`](https://github.com/pwittchen/aictl/blob/master/docs/CONFIG.md).

Once configured, you can do things like:

```bash
# interactive REPL
aictl

# single message
aictl --message "What is Rust?"

# autonomous mode, no confirmation prompts on tool calls
aictl --auto --message "List the largest files in this directory"
```

All state - config, sessions, audit log, agents and skills - lives in `~/.aictl/`, so it's easy to inspect and back up.

## Coding agent mode

There is also an experimental coding-agent mode, where AICTL takes a higher-level task and drives the editor, shell and file system on its own to get the work done. To be honest, it's nowhere near as advanced as [Claude Code](https://www.anthropic.com/claude-code) and I'm not trying to compete with it - Claude Code has years of work behind it, a much richer tool surface and, most importantly, a flat-fee subscription that makes heavy use actually affordable. Driving the same Claude models through the API in AICTL works, but per-token billing for an agent that loops on tool calls adds up fast, so financially it doesn't really make sense compared to the Claude subscription.

That said, the mode is more capable than I expected for a side project. While testing it I was able to generate a few working things end-to-end: a small web app with a todo list in Python, the same in Go, and another version in Java, plus a Conway's Game of Life implementation in C. Nothing fancy, but it confirms that the agent loop, tools and context handling are good enough for simple apps and self-contained algorithms. For anything bigger I'd still reach for a dedicated coding agent, but for quick "write me a small X in language Y" it works.

## The server part

`aictl-server` is the one I'm probably most happy about. It exposes the same provider catalogue over an OpenAI-compatible HTTP endpoint, with redaction and audit baked in. It's a pure proxy - no agent loop, no tools - so it can sit in front of the CLI on multiple client machines, keeping provider keys and audit centralised on the server, with a single master key on each client.

```
   ┌──────────┐                          ┌─────────────────┐
   │  laptop  │                          │     OpenAI      │
   │  aictl   │──┐                    ┌──│   Anthropic     │
   └──────────┘  │   master key       │  │     Gemini      │
                 │   ┌──────────────┐ │  │     Ollama      │
   ┌──────────┐  └──▶│ aictl-server │─┤  │     ...         │
   │  laptop  │      │   (proxy +   │ │  └─────────────────┘
   │  Claude  │────▶ │   redaction  │ │
   │   Code   │      │   + audit)   │ │
   └──────────┘  ┌─▶ └──────────────┘ │
                 │                    │
   ┌──────────┐  │                    │
   │  laptop  │──┘                    │
   │  aictl   │                       │
   └──────────┘                       │
                                      ▼
                                provider keys
                              stay on the server
```

It can also serve as a custom inference provider for Claude Code, including opt-in cross-provider routing that translates Claude's `POST /v1/messages` to and from OpenAI, Gemini, Ollama and the rest. Useful if you like Claude Code's UX but want to use a different model underneath.

## Releases, Apple signing and in-app updates

Releases are fully automated on GitHub Actions. A tag push triggers a workflow that builds the CLI and the desktop app for both Apple Silicon and Intel, code-signs the `.app` bundle with a Developer ID certificate, submits it to Apple's notary service with `notarytool` and staples the resulting ticket back into the bundle. The signed and notarized `.app` is then wrapped into a `.dmg` and published as a GitHub release.

This is the path Apple actively recommends for distributing macOS apps outside the App Store, and in practice it's not really optional - a modern macOS won't let a normal user install an unsigned and unnotarized app without bypassing system permissions (right-click → Open, disabling Gatekeeper, or digging through "Privacy & Security" to allow the app anyway). I didn't want first-time users to have to do any of that, so I set up the full Developer ID + notarization pipeline from day one. After install the app simply opens, like any other native macOS app.

```
  git tag v0.x.0
        │
        ▼
  ┌─────────────┐    build     ┌──────────────┐
  │   GitHub    │─────────────▶│  CLI + .app  │
  │   Actions   │              │  (arm64+x64) │
  └─────────────┘              └──────┬───────┘
                                      │
                                      ▼
                        ┌──────────────────────────┐
                        │  codesign (Developer ID) │
                        │  notarytool submit+wait  │
                        │  staple ticket           │
                        └─────────────┬────────────┘
                                      │
                                      ▼
                        ┌──────────────────────────┐
                        │  .dmg + .app.tar.gz+.sig │
                        │  GitHub release + updater│
                        │  manifest (latest.json)  │
                        └─────────────┬────────────┘
                                      │
                                      ▼
                        installed app checks for updates,
                        verifies minisign signature,
                        replaces itself in place
```

The desktop app uses `tauri-plugin-updater`, so an already-installed instance can check the release feed, download the new bundle, verify its minisign signature and swap itself in place without me having to ship a separate auto-updater. End users just see "update available", click once and they're on the latest build a minute later.

## Why I'm sharing this

I built AICTL mostly to test what's possible with agentic development today, but the result turned out to be genuinely useful, so it's open-source from day one. If you give it a try, feedback and bug reports are very welcome on the [issue tracker](https://github.com/pwittchen/aictl/issues). Documentation is in the [`docs/`](https://github.com/pwittchen/aictl/tree/master/docs) directory in the repo - install instructions, config keys, supported providers with per-token pricing, built-in tools, extensions and architecture diagrams.

Project website: [aictl.app](https://aictl.app).
