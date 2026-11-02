---
title: "nazarewav.es: simulating the Nazaré waves in the browser"
date: 2026-11-02
tags:
- surfing
- typescript
- react
- three.js
- webgl
- ai
- open-source
---

<img src="/projects/nazarewaves.png" alt="nazarewav.es logo" width="120" style="border: none;">

Nazaré is a small fishing town in Portugal, and every winter it becomes the place where the biggest waves in the world get surfed. On a good day, swells of 20 metres and more break at Praia do Norte, right below the old fort with the red lighthouse, while thousands of people watch from the cliff. I wanted to understand why these waves get so big in this one spot, so I built [nazarewav.es](https://nazarewav.es), a 3D wave simulator that runs in the browser. The source code is on [GitHub](https://github.com/pwittchen/nazarewav.es).

## What it is

The simulator shows the Nazaré coast, the town and the ocean in 3D, with waves animated in real time. You can orbit the camera, zoom in and change the conditions with a control panel:

- the **primary swell**: height, period and the direction it comes from,
- a **secondary swell** crossing the main one,
- **wind** speed and direction, which add chop and can blow out the waves,
- the strength of the **canyon effect**,
- **sky and weather**: time of day, cloud cover and a live mode that follows the current time in Nazaré.

There are four presets: Calm, Moderate, Big and Extreme. Extreme is the classic tow-in day, a 9 m long-period swell from the north-west under a light offshore wind. Big and Extreme also move the camera to a viewpoint over the canyon looking north past the fort, which is roughly the angle the crowds on the headland see.

{{< rawhtml >}}
<img src="/posts/2026/nazare/nazare_extreme.png" alt="nazarewav.es - Extreme preset" style="border: none;">
{{< /rawhtml >}}

When the page loads, it fetches the current forecast for Nazaré from Windguru and applies the nearest hour to the simulation, so by default you see something close to what's happening there right now. In the forecast panel you can pick any other hour of the week and see how the sea will look.

{{< rawhtml >}}
<img src="/posts/2026/nazare/nazare_forecast.png" alt="nazarewav.es - forecast panel" style="border: none;">
{{< /rawhtml >}}

A few more things to play with:

- **surfers**: when the conditions can be surfed, surfers wait in the lineup, catch set waves and ride them. Above 6 m they switch to tow-in and each one gets a jet ski that follows them and picks them up after the ride,
- **drone flight**: a slow cinematic orbit over the bay between the canyon peak and the fort,
- the **town**: one house per OpenStreetMap building footprint, the funicular going up to Sítio with animated cars, the fort with a rotating lighthouse beam at night, fishing boats on the beach,
- an **embed mode**: the panel gives you an iframe snippet, so you can put the simulator on your own page.

## Why the waves are so big

The usual explanation is that the Nazaré Canyon, an underwater canyon about 230 km long that ends almost at the beach, "channels" the swell towards the shore. My first version of the simulator did more or less that. It had a hand-tuned canyon amplification factor, which made the waves near the beach bigger. It looked fine, but it wasn't really based on anything.

Then I found a preprint by Hope et al. (2026), [*Focusing of Swell at the Nazaré Submarine Canyon*](https://egusphere.copernicus.org/preprints/2026/egusphere-2026-2778/). The picture it gives is more interesting than channelling:

- **refraction**: the shelf slopes down towards the canyon rim, which bends the swell so it meets the rim at a more oblique angle. Where the canyon turns north near the fort, it casts a shadow,
- **reflection at the rim**: the edge of the canyon acts like a trench. Long-period swell coming in at an oblique angle gets reflected from it, completely above a critical angle. Short waves, below about 7 seconds, or waves hitting the rim head on mostly pass through,
- **interference**: the reflected waves cross the incoming ones. Where they add up, beams of focused energy run towards Praia do Norte, with high peaks along them and gaps in between,
- **pyramid peaks**: crossing seas can build higher crests before they break (McAllister et al., 2024), which is where the famous A-frame peaks come from.

So I removed the fake amplification and rebuilt the wave model on top of these findings.

## Real data instead of hand-placed effects

To make the model mean anything, the coast and the seabed have to be real. The simulator uses:

- **bathymetry** from [EMODnet](https://emodnet.ec.europa.eu/en/bathymetry) (~115 m resolution),
- **land elevation** from the Mapzen/AWS Terrain Tiles (EU-DEM over Europe),
- **coastline, buildings, roads and land cover** from [OpenStreetMap](https://www.openstreetmap.org/copyright).

A Node script downloads the raw data and bakes it into small binary files that ship with the app. The world is in metres, 1:1 and aligned with the compass, with the origin near the fort. The fort rock is too small for the 25 m elevation model, so it's the one piece of terrain added by hand.

On top of that, the wave model runs in plain TypeScript, without Three.js:

1. rays are traced over the seabed for the given swell direction and period, which gives the energy, refraction, focusing and the canyon shadow,
2. where rays cross the 50 m depth contour (the boundary used in the paper), they split into a transmitted and a reflected part, using the trench reflection coefficient from Kirby & Dalrymple (1983),
3. the reflected rays carry their own phase and are summed with the incoming swell. Close to the rim the sum is coherent, which produces the interference beams. Further away it becomes incoherent,
4. an eikonal solve gives the phase of the incoming swell, so the crests bend as they come in, and linear wave theory handles shoaling,
5. the breaker index is raised where the two trains cross, to get the pyramid peaks.

The field is re-solved in about 250 ms whenever you change the swell direction or period. The model reproduces the cut-offs from the paper: near-total reflection of swell from 300° above about 10 s on the outer edge of the rim and 12 s on the middle one, with the inner edge mostly letting it through. Nothing about the amplification is placed by hand anymore. If you set the canyon effect to 0, you can see what Praia do Norte would look like without it.

Wave sets are random too, but not arbitrary. Set peaks follow a Rayleigh distribution scaled so that the sea state has exactly the configured significant wave height, which is why you sometimes wait a while for a big one, just like on the real cliff.

## Under the hood

The app is built with:

- **TypeScript** and **React**,
- **Three.js** through **React Three Fiber** and **Drei**,
- **Vite** and **Bun** for the build,
- **GitHub Pages** with GitHub Actions for deployment.

There are two water meshes. Close to the surf zone there's a 300×300 m mesh animated on the CPU, which samples the solved wave field for every vertex and adds the secondary swell, wind chop and foam. Beyond it, a GPU ocean reaches out to ±2.4 km. Its vertex shader repeats the same surface formula, and gets the wave field as a half-float texture (phase, gain and the crossing terms) plus a depth texture. The terrain is shaded per pixel: OSM land cover is turned into blurred masks with noisy edges, and the shader adds cliff strata, pine forest, fields, wet sand, roads and the Portuguese *calçada*. The sky is procedural, with the real sun position over Nazaré for the chosen time of day, and the water reflects it.

## Built with AI

Like my other recent side projects, this one was built with a lot of help from coding agents. The interesting part was reading the paper together with an agent and turning its findings into code. That meant ray tracing, the reflection coefficient, coherent and incoherent summation, and checking that the cut-offs match the ones in the paper. I'm a software engineer, not an oceanographer, and doing this alone would have taken me far longer. I still had to check the results and say no to the parts that looked good but didn't match the physics.

## Summary

nazarewav.es started as a toy with a sine wave and a slider, and slowly turned into a small model of a real place. I learned more about waves and seabed physics while working on it than I expected. If you're curious why Nazaré is Nazaré, open [nazarewav.es](https://nazarewav.es), pick the Extreme preset and turn on the surfers. If something looks wrong or you have an idea, open an issue on [GitHub](https://github.com/pwittchen/nazarewav.es/issues).

## References

- Hope, G. et al.: *Focusing of Swell at the Nazaré Submarine Canyon*, EGUsphere preprint, 2026, [doi:10.5194/egusphere-2026-2778](https://doi.org/10.5194/egusphere-2026-2778)
- Kirby, J. T. and Dalrymple, R. A.: *Propagation of Obliquely Incident Water Waves over a Trench*, Journal of Fluid Mechanics, 133, 47–63, 1983
- McAllister, M. L. et al.: *Three-Dimensional Wave Breaking*, Nature, 633, 601–607, 2024
