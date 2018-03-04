---
title: Air quality monitoring script for Argos (Linux) and BitBar (macOS)
date: 2017-12-29 10:02:00
tags:
	- bash
	- linux
	- macos
	- air-quality
	- airly
---

From some time, I wanted to create my own app, which will display some data in top panel in macOS or Gnome environment on Linux. I collected some resources about that and I knew that for macOS I need to write an app in Obj-C and for Gnome I need to write a plugin in JavaScript. In both cases it requires some ceremony and preparation. Recently I've found a great app for macOS called [BitBar](https://getbitbar.com/) (by the way it's [open-source](https://github.com/matryer/bitbar)). BitBar allows to put anything to macOS menu bar (top panel) in no time! With this project creating top panel apps is simplified to the limit. Moreover, there's another project called [Argos](https://extensions.gnome.org/extension/1176/argos/), which does the same thing, but for Linux with Gnome (it's an [open-source](https://github.com/p-e-w/argos) Gnome Extension). In both cases, we just need to create a shell script, put it into appropriate directory (in case of Argos, it's `~/.config/argos/` and in case of BitBar, we define it during the installation or first run) and then app displays our data automatically. We can also set refresh rate. E.g. if we want our script to be executed every 60 seconds, we can name it `script.60s.sh`. We can also create more advanced scripts and more details can be found in BitBar and Argos documentation. In my case, I wanted to create a script, which reads `CAQI` (Common Air Quality Index) in my current location based on [Airly](http://airly.eu/) sensors. Airly provides nice [API](https://airly.eu/en/api/), which we can use in our projects. Please remember that most of the sensors are located in Poland. On my Ubuntu Linux with Gnome 3, I created a new script in the following path:

```
~/.config/argos/caqi.60s.sh
```

For a BitBar script location could be different. Both for BitBar and Argos follow the same naming convention. My script looks as follows:

```bash
#!/usr/bin/env bash

CAQI=$(curl -s -X GET --header 'Accept: application/json' --header 'apikey: YOUR_API_KEY' \
    'https://airapi.airly.eu/v1/nearestSensor/measurements?latitude=YOUR_LATITUDE&longitude=YOUR_LONGITUDE&maxDistance=1000' \
    | jq .airQualityIndex | cut -f1 -d".")

MSG="Unknown"

case 1 in
  $(($CAQI <= 25)))  MSG="Great!";;
  $(($CAQI <= 50)))  MSG="Good!";;
  $(($CAQI <= 75)))  MSG="Medium";;
  $(($CAQI <= 100))) MSG="Bad";;
  $(($CAQI >= 101))) MSG="Very Bad";;
esac

echo "CAQI: $CAQI ($MSG)"
```

It works fine on Linux. The only requirement is to install [jq](https://stedolan.github.io/jq/). For macOS, I needed to change `jq` to `/usr/local/bin/jq` to make it work. I gathered information about air quality level from this website: [https://www.airqualitynow.eu/pl/about_indices_definition.php](https://www.airqualitynow.eu/pl/about_indices_definition.php) [PL]. Of course, we need to replace `API_KEY` with our api key, which we can get from [https://developer.airly.eu/](https://developer.airly.eu/) website as well as `YOUR_LATITUDE` and `YOUR_LONGITUDE` with coordinates of our location. It can be static location in our city. We can get them e.g. from Google Maps. 

As a result, we have beautiful text in our top panel: 

![](/images/posts/2017/air-quality-monitoring-script-for-argos-linux-and-bitbar-macos/caqish.png)

This screenshot was taken on Ubuntu Linux with Gnome 3. On macOS it works the same (I checked it).
