# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hugo static site for wittchen.io, a personal website and blog using the PaperMod theme.

## Common Commands

**Development server (with drafts):**
```
hugo server -D
```

**Build for production:**
```
hugo -D
```

**Create new note:**
```
hugo new content/notes/my-new-note.md
```

**Docker development:**
```
docker compose up -d           # Start (localhost:1313)
docker compose up -d --build   # Rebuild and start
docker compose down --rmi all -v  # Stop and remove everything
```

## Architecture

- `config.yml` - Hugo configuration (theme settings, menus, profile mode)
- `content/` - Markdown content organized by section:
  - `notes/` - Blog posts (158+ articles)
  - `talks/`, `projects/`, `setup/`, `contact/` - Static pages
- `layouts/shortcodes/` - Custom shortcodes (includes `rawhtml` for embedding raw HTML)
- `themes/papermod/` - PaperMod theme (third-party)
- `static/` - Static assets
- `public/` - Generated output (gitignored, built in CI)

## Deployment

Automatic via GitHub Actions on push to master. The workflow builds the site with Hugo and deploys via FTP using repository secrets.

Workflow: Push to master, GitHub Actions runs `hugo -D` and deploys the generated `public/` directory.
