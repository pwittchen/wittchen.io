---
title: "varun.surf: kite spots and wind forecasts"
date: 2026-10-27
tags:
- kitesurfing
- java
- spring-boot
- android
- kotlin
- ai
- open-source
---

<img src="/projects/varun.png" alt="varun.surf logo" width="120" style="border: none;">

Every kitesurfer knows the morning routine: open Windguru for one spot, then Windfinder for another, then a live station in a third tab, then ICM, then go back to the first tab because you forgot what it said. I did this for years, so in May 2025 I started building [varun.surf](https://varun.surf). It's a kite spot database and wind forecast site that puts forecasts and live conditions for many spots on a single page. Since a few days ago it also has a native [Android app](https://play.google.com/store/apps/details?id=surf.varun.app). Source code is on [GitHub](https://github.com/pwittchen/varun.surf).

## What it is

At the moment varun.surf covers about 830 kite spots in 59 countries. For each spot you get:

- a multi-day forecast (wind, gusts, direction, temperature, rain, waves) with a daily and an hourly view,
- live wind conditions from weather stations, refreshed every minute,
- a description of the spot in English and Polish, a map, a photo, a webcam and links to Windguru, Windfinder and ICM,
- a forecast model selector with 40+ Windguru models, discovered automatically for each spot.

You can filter spots by country, search them, add them to favourites and reorder them with drag and drop. You can switch between a grid view and a list view, and pick a dark or light theme. There's also a kite and board size calculator, a TV-friendly view for a single spot and an embeddable HTML widget you can put on your own website.

{{< rawhtml >}}
<img src="/posts/2026/varun/varun_web.png" alt="varun.surf on desktop and mobile" style="border: none;">
{{< /rawhtml >}}

## Maps and the wind field

The part I'm happiest with is the map. All spots sit on top of satellite tiles, and you can turn on a wind field overlay with a heatmap and animated wind particles. A timeline below the map moves through the whole forecast run hour by hour. Popups follow the timeline and show the wind, gusts and direction for the selected hour. On desktop, a side peek shows the live conditions and forecast for a spot without leaving the map, and a globe view shows the same data on a rotating planet.

{{< rawhtml >}}
<img src="/posts/2026/varun/varun_map.png" alt="varun.surf map with the wind field overlay" style="border: none;">
{{< /rawhtml >}}

## Under the hood

The stack is deliberately boring:

- **backend**: Java 25, Spring Boot (WebFlux), Gradle,
- **frontend**: vanilla JS, HTML and CSS bundled with Bun and served by the backend,
- **infra**: Docker, Docker Compose, Nginx, GitHub Actions, GHCR, Cloudflare and a small [Mikrus](https://mikr.us) VPS.

The backend fetches forecasts every 3 hours and live conditions every minute, then keeps everything in memory. Fetching hundreds of spots from several sources runs concurrently with `StructuredTaskScope` and virtual threads from Java 25. Each weather station provider has its own strategy class. If the primary station returns stale data, the app falls back to another one, and the UI marks outdated readings in yellow.

Deployment is a blue/green setup with two app containers behind Nginx, so a new version goes live without downtime. Pushing a tag with a `v` prefix triggers the CD pipeline, which builds the Docker image, pushes it to GHCR and deploys it to the VPS. After a deployment, the Cloudflare cache is purged and content-hashed assets make sure nobody sees an old CSS file. There's a maintenance mode, a [status](https://varun.surf/status) page, a [metrics](https://varun.surf/metrics) dashboard and a list of [data sources](https://varun.surf/sources).

The data is public, but I didn't want the API to become a free backend for someone else's app. Nginx applies per-IP rate limits (behind Cloudflare, so it reads the real client address). The API also requires a signed session cookie, which the site sets when you load a page.

## Built for AI agents too

Since more and more people ask an LLM instead of opening a website, varun.surf exposes its data in two AI-friendly ways:

- **LLM-friendly Markdown** endpoints under `/llms/*.md`, linked from [`/llms.txt`](https://varun.surf/llms.txt),
- a built-in **MCP server**, implemented with Spring AI, that exposes tools like `list_spots`, `get_spot`, `get_wind_forecast`, `find_spot_by_name` and `find_windy_spots`.

You can add it to Claude Code with one command:

```
claude mcp add --transport sse varun-surf https://varun.surf/mcp/sse
```

Then you can ask things like *"which spots in Poland will have more than 15 knots this weekend?"* and get an answer based on the real forecast. The [/mcp](https://varun.surf/mcp) page has the config ready to copy.

There's also an optional AI forecast analysis and an ICM meteogram reader that uses a vision model. Both are off by default and only run when someone presses a button on a spot page. The results are cached for 24 hours. These features used to run on a timer for every spot, which spent most of the budget on spots nobody looked at that day. Generating them on demand ties the cost to actual usage.

## The Android app

The website works fine on a phone, but some things only a native app can do, like home screen widgets and wind alerts. So I wrote an Android app. It's a native Kotlin app built with Jetpack Compose (Material 3), Navigation 3, Hilt, Room, Retrofit, MapLibre, WorkManager and Glance, split into `core`, `feature` and `widget` modules.

{{< rawhtml >}}
<div style="display: flex; gap: 12px; flex-wrap: wrap; justify-content: center;">
  <img src="/posts/2026/varun/varun_android_spots.png" alt="varun.surf Android - spots" style="border: none; width: 30%; min-width: 180px;">
  <img src="/posts/2026/varun/varun_android_spot.png" alt="varun.surf Android - spot details" style="border: none; width: 30%; min-width: 180px;">
  <img src="/posts/2026/varun/varun_android_map.png" alt="varun.surf Android - map" style="border: none; width: 30%; min-width: 180px;">
</div>
{{< /rawhtml >}}

What it offers on top of the website:

- **offline-first** data: Room is the source of truth, so the last forecast is available even without a connection,
- **wind alerts**: you pick a spot, a minimum (and optionally a maximum) wind speed and wind directions, and a background worker sends a notification when the forecast matches,
- **home screen widgets** for a single spot and for your favourites,
- **deep links**: `varun.surf/spot/{id}` links open directly in the app,
- the same **map with the wind field** and particles, plus a globe view drawn with Compose Canvas.

The rules that matter (wind classes, staleness, the calculator, the wind field maths) are ported from the web frontend into a pure Kotlin `core/domain` module. The calculator has golden tests against the JavaScript version, so both platforms give the same kite size for the same input.

The app was built from a written specification (`SPEC.md`) with a lot of help from coding agents. The website has been evolving for a year and a half, while the first working version of the Android app took only a few days. Having a detailed spec, a stable backend API and the web frontend as a reference implementation made a big difference here.

You can get it on [Google Play](https://play.google.com/store/apps/details?id=surf.varun.app).

## Summary

varun.surf started as a tool for my own sessions, and it's still the first thing I open when I check whether it's worth driving to the spot. If you kite, give it a try at [varun.surf](https://varun.surf) or on [Android](https://play.google.com/store/apps/details?id=surf.varun.app). If a spot you ride is missing or something doesn't work, open an issue on [GitHub](https://github.com/pwittchen/varun.surf/issues).

See you on the water!
