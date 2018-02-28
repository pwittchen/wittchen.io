---
title: Control Spotify on Linux like a hacker
date: 2017-03-05 22:40:00
tags:
	- linux
	- python
	- spotify
---

Recently, I created a tiny script called [spotify-cli](https://github.com/pwittchen/spotify-cli-linux), which allows you to control [Spotify](http://spotify.com) on Linux from terminal. It's inspired by [shpotify](https://github.com/hnarayanan/shpotify), which is a shell script doing similar things, but on macOS. My script is written in Python and uses [dbus](https://dbus.freedesktop.org/doc/dbus-python/doc/tutorial.html) under the hood, which allows to communicate with bus daemon to pass messages between applications. I used [pactl](https://linux.die.net/man/1/pactl) for controlling the system sound. 

You can install spotify-cli as follows via wget:

```
sh -c "$(wget https://raw.githubusercontent.com/pwittchen/spotify-cli-linux/master/install.sh -O -)"
```

or via curl:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pwittchen/spotify-cli-linux/master/install.sh)"
```

After that, you can just type `spotifycli` in your terminal. You can use `spotifycli` with the following parameters:

```
--help, -h          shows help
--status            shows status (currently played song name and artist)
--status-short      shows status in a short way (cuts currently played song name and artist)
--play              plays the song
--pause             pauses the song
--playpause         plays or pauses the song (toggles a state)
--next              plays the next song
--prev              plays the previous song
--volumeup          increases sound volume
--volumedown        decreases sound volume
```

That's it! Happy listening! 

Source code of the project can be found at [https://github.com/pwittchen/spotify-cli-linux](https://github.com/pwittchen/spotify-cli-linux).