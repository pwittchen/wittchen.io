---
title: Spotify song in i3 status bar
tags:
  - linux
  - i3
  - python
date: 2020-02-20 11:29:13
---


While customizing my i3 status bar, I wanted to have currently played Spotify song in it. Some time ago, I created an open source script in Python called [spotify-cli-linux](https://github.com/pwittchen/spotify-cli-linux) and I wanted to use it. When we want to put something custom into the i3 status bar, the easiest way to do it, is to save data into the file and then read the file.

I created the following config inside `~/.config/i3status/config` file:

```bash
order += "read_file spotify"

...

read_file spotify {
        format = "♪ %content"
        path = "/var/log/scripts/spotify.log"
}

....
```

## Approach #1 - cron job

The i3 status bar is refreshed automatically according to the configuration. Now, I just needed the way to save the song into the `/var/log/scripts/spotify.log` file. My first idea was to create a cron job, which will save the song every given interval.


```bash
*/2 * * * * /usr/bin/spotifycli --statusshort > /var/log/scripts/spotify.log
```

Typical song has 2 minutes or more, so it should work. Unfortunately, my script uses `dbus` under the hood, which doesn't have an access to the session of the desktop user. After searching the web for a while, I noticed that passing data from the user session into this script is not a trivial thing and cannot be done quickly. I decided to search for another solution.

## Approach #2 - media buttons

I wanted to be able to control spotify via media buttons on my keyboard. On i3 it doesn't work out of the box, and we need to configure it. To do that, I added the folloiwng key bindings in `~/.config/i3/config` file:

```bash
bindsym XF86AudioPlay exec "spotifycli --playpause"
bindsym XF86AudioNext exec "spotifycli --next"
bindsym XF86AudioPrev exec "spotifycli --prev"
```

It works fine. We can also improve it, to make it work with other players, make it more general, etc., but in my case I use just Spotify for the music and podcasts, so it's enough for me.

We can update this functioanlity to save song whenever we change it or start it:

```bash
bindsym XF86AudioPlay exec "spotifycli --playpause && spotifycli --statusshort > /var/log/scripts/spotify.log"
bindsym XF86AudioNext exec "spotifycli --next && spotifycli --statusshort > /var/log/scripts/spotify.log"
bindsym XF86AudioPrev exec "spotifycli --prev && spotifycli --statusshort > /var/log/scripts/spotify.log"
```

and this will work, but unfortunately, when song will change automatically on the playlist, status won't be updated, so this solution is not right.

## Approach #3 (correct) - notifications

Spotify desktop application is sending notifications whenever the song changes. On i3, we need to install notification daemon/server, to make it work. On [Arch Wiki](https://wiki.archlinux.org/index.php/Desktop_notifications#Notification_servers), we can see list of the popular daemons. I decided to use [Dunst](https://dunst-project.org/) because it's simple, light-weight, open-source, configurable, is actively developed and supported by its maintainers. Once I installed Dunst and started it to enable daemon, I started receiving system notifications (including Spotify).

I edited Dunst configuration in `~/.config/dust/dunstrc` file and added handler for Spotify:

```bash
[spotify]
    appname = Spotify
    urgency = normal
    script  = ~/.scripts/spotify_log.sh
```

`spotify_log.sh` script looks as follows:

```bash
#!/usr/bin/env bash
/usr/bin/spotifycli --statusshort > /var/log/scripts/spotify.log
```

Now, whenever I receive a system notification from Spotify that song is changed, currently played song is saved into the file, this file is read by i3 status bar and refreshed in a given interval. Thanks to that, it doesn't matter if song changes itself or I change it - it's updated anyway and that's what I wanted.

![](/posts/2020/spotify-song-in-i3-status-bar/i3bar_spotify.png)
