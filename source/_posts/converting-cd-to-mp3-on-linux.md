---
title: Converting audio CD to mp3 files on Linux
date: 2016-01-24 17:24:00
tags:
	- linux
---

Not all songs are available on [Spotify](https://www.spotify.com) and sometimes we need to rip music from audio CDs in order to listen it on our computer or mobile device. There are several approaches to do that. Here is mine: Get [RipperX](http://ripperx.sourceforge.net/screenshots.html):

sudo apt-get install ripperx

Put audio CD into your computer. Open RipperX, select All Tracks and check Rip to WAV option. Set quality of output files via "Config" option and names of the tracks if your want. Press "Go!". After conversion, you should have directory with ripped `*.wav` files in your home directory. Get [SoundConverter](http://soundconverter.org/):


```
sudo apt-get install soundconverter
```

Run it and convert `*.wav` files to `*.mp3`. You can choose another output format if you want. Get [EasyTag](https://wiki.gnome.org/Apps/EasyTAG):

```
sudo add-apt-repository ppa:amigadave/ppa
sudo apt-get update
sudo apt-get install easytag
```

Open EasyTag and set appropriate tags for your `*.mp3` files. You can also set CD cover as image for each file. **You are done!** Now, you can import files to your favorite music player. I'm using Spotify right now, where I can select local files, create a playlist and even sync it with my mobile device if my computer is in the same WiFi network. It's very handy option. I hope, this short tutorial will be helpful for you.