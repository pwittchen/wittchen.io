---
title: Software for common users on Ubuntu
date: 2014-08-18 16:17:00
tags:
	- ubuntu
	- linux
---

In this article, I'll describe Ubuntu software for common users, which I personally use and which could be helpful on daily basis. Ubuntu software dedicated to programmers AKA developers will be described in separate article.

Chrome
------

In my opinion, it's currently the best web browser. We can download, unpack and install it, with the following commands:

```
sudo apt-get install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable\_current\_amd64.deb
sudo dpkg -i google-chrome*.deb
```

Skype
-----

Maybe it's not the best, but one of the most known messengers and lot of people use it. In addition, at my work people currently use it as a common messenger. We can download and install it with the following commands (first command adds new software repository, from which Skype can be downloaded):

```
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update
sudo apt-get install skype
```

Spotify
-------

After I started using Spotify, I stopped keeping all my mp3s on the hard drive. Of course, it has pros and cons, but for now I think that Spotify is good choice for people who like to listen to the music quite often. In addition, premium version is quite cheap. We can download and install Linux version of the Spotify with the following commands:

```
sudo sh -c 'echo "deb http://repository.spotify.com/ stable non-free" > /etc/apt/sources.list.d/spotify.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-get update
sudo apt-get install spotify-client
```

**Disabling notifications after starting new song** Notifications, which appears after starting new song are enabled by default. They are annoying for me, so I decided to turn them off. I've edited file: `~/.config/spotify/Users/[Spotify user name]/prefs` and set `ui.track_notifications_enabled=false`. After that, I restarted Spotify and notifications disappeared.

Dropbox
-------

Dropbox is great software. I often use it to backup my files and when I want to access specific files on different devices. We can install it with the following command: `cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -` After installing, we can launch Dropbox with the following command: `~/.dropbox-dist/dropboxd` We can execute the following command to run Dropbox in the background even if we close terminal: `nohup ~/.dropbox-dist/dropboxd` Unfortunately, Dropbox is not launched on autostart after rebooting computer, so I installed additional software, which runs Dropbox in the background on startup and displays indicator icon. I just typed the following commands:

```
sudo apt-get install libappindicator1
sudo apt-get install nautilus-dropbox
```

Deluge
------

Deluge is lightweight torrent client similar to uTorrent and BitTorrent. We can install it by typing the following command: 

```
sudo apt-get install deluge
```

Transmission
------------

Yet another light torrent client. Install it with: 

```
sudo apt-get install transmission
```

Java
----

Many programs are written in Java, so if we want to use them, we have to have Java Virtual Machine installed on the system. Using Oracle **Java 7** is not formally supported by Ubuntu. There's plenty solutions for installing it, listed on [https://help.ubuntu.com/community/Java](https://help.ubuntu.com/community/Java). The simplest one listed is this one:

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

It'll keep your java 7 installation up to date. To automatically set up the Java 7 environment variables `JAVA_HOME` and `PATH`: `sudo apt-get install oracle-java7-set-default` **Enabling global menu (HUD) support in Swing applications** Some Java Swing applications do not support global menu (HUD) available in Unity environment enabled by default in Ubuntu. This problem occurs often in applications for software developers like IntelliJ IDEA, Android Studio, PyCharm, Netbeans, etc. but it may also occur in any Swing application. We can enable this menu by installing `jayatana` in the following way:

```
sudo add-apt-repository ppa:danjaredg/jayatana
sudo apt-get update
sudo apt-get install jayatana
```

Source of this solution: [http://www.webupd8.org/2014/02/get-unity-global-menu-hud-support-for.html](http://www.webupd8.org/2014/02/get-unity-global-menu-hud-support-for.html)

Wine
----

Wine is a software, which allows to run some MS Windows applications on Linux. For sure it works with Adobe Photoshop CS2. We can install it with the following command: 

```
sudo apt-get install wine
```

Gthumb
------

Small and useful image browser and editor. Use the command below to install it. 

```
sudo apt-get install gthumb
```

Pinta
-----

Pinta is simple, lightweight image editor. We can install it with the following command: 

```
sudo apt-get install pinta
```

Furious ISO Mount
-----------------

Furious ISO Mount is application similar to Virtual Clone Drive or Daemon Tools available on Windows, which allows us to mount images of the CD into virtual drive. We can install it in the following way: 

```
sudo apt-get install furiusisomount
```

Virtual Box
-----------

Virtual Box allows us to use virtual machines and install on them e.g. MS Windows 7, 8, different Linux distributions or any other operating system and use it in dedicated sandbox. We can install it with the following command:

```
sudo apt-get install virtualbox
```

Gedit
-----

Gedit is simple, but very good text editor and a little bit enhanced notepad. It's available on Ubuntu by default, but in case you don't have it, use the following command to get it: 

```
sudo apt-get install gedit
```

Clementine
----------

Ubuntu has one music player installed by default. It's called Rhythmbox. It looks ok, but it had problems with playing my mp3 files. Problem could be connected both with the drivers and this software. I decided to try another lightweight music player called Clementine. It's small, configurable and works fine with my mp3s right after installing. Use the following command to download and install it:

```
sudo apt-get install clementine
```

VLC
---

VLC is one of the best video players for MS Windows and Linux. You should have it if you want to play your videos without problems. Use the following command to install VLC: 

```
sudo apt-get install vlc browser-plugin-vlc
```

Drivers for Logitech H760 Wireless Headset
------------------------------------------

I am using Logitech H760 Wireless Headset and it does not work on Ubuntu by default. In order to bring it to work we have to install additional software in the following way:

```
sudo add-apt-repository ppa:ubuntu-audio-dev/ppa
sudo apt-get update
sudo apt-get dist-upgrade -y
```

After connecting headset receiver, I had to change output of the sound and input of the microphone to my headset in system settings. Previously it was set to loud speakers. After switching back to loud speakers, I have to change output of the sound to speakers to hear sound in the speakers. It's quite inconvenient, but I don't know, how to automate it. In MS Windows it switches automatically without additional drivers or additional operations, so probably manufacturer should take care of this in case of Linux OS.

Something else?
---------------

I guess I listed most of the common Ubuntu software I use (besides of course Terminal, System Monitor and programming tools ;-). If you know any useful software, which wasn't listed here, write about it in comments below this article. I would be happy to update this post.
