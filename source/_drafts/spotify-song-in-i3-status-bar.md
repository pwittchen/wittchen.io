---
title: Spotify song in i3 status bar
tags:
    - linux
    - arch
    - i3
    - python
    - bash
---

While customizing my i3 status bar, I wanted to have currently played Spotify song in it. Some time ago, I created an open source script in Python called [spotify-cli-linux](https://github.com/pwittchen/spotify-cli-linux) and I wanted to use it. When we want to put something custom into the i3 status bar, then the easiest way to do it, is to save data into the file and then read the file.

I created the following config:

```bash
order += "read_file spotify"

...

read_file spotify {
        format = "♪ %content"
        path = "/var/log/scripts/spotify.log"
}

....
```

## approach #1 - cron job

The i3 status bar is refreshed automatically according to the configuration. Now, I just needed the way to save the song into the `/var/log/scripts/spotify.log` file. My first idea was to create a cron job, which will save the song every given interval.


```bash
*/2 * * * * /usr/bin/spotifycli --statusshort > /var/log/scripts/spotify.log
```

Typical song has 2 minutes or more, so it should work. Unfortunately, my script uses `dbus` under the hood, which doesn't have an access to the session of the desktop user. After searching the web for a while, I noticed that passing data from the user session into this script is not a trivial thing and cannot be done quickly. I decided to search for another solution.

## approach #2 - media buttons

...

## appraoch #3 (correct) - notifications

Spotify desktop application is sending notifications whenever the song changes.
