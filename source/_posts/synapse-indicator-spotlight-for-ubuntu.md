---
title: Synapse Indicator - Spotlight for Ubuntu
date: 2014-12-25 17:06:00
tags:
	- ubuntu
	- linux
---

Introduction
------------

If you were using Ubuntu for some time, you might have noticed that Ubuntu Dash from Unity is working quite slow. We can disable on-line search or a few other elements, but it's still very slow. If we want to have fast search, we can use external software like synapse.

Synapse
-------

Synapse is searching really fast and we don't have to wait a few seconds like in Ubuntu Dash or disable some search options. ![synapse](/images/posts/2014/synapse-indicator-spotlight-for-ubuntu/synapse.jpg) Synapse can be installed with the following commands:

```
sudo add-apt-repository ppa:synapse-core/ppa
sudo apt-get update
sudo apt-get install synapse
```

After installing it, in Synapse Preferences we can set appropriate shortcut for opening Synapse.

Synapse Indicator
-----------------

If we want to have "Mac OS-like" experience, we can use Synapse Indicator which is similar to Spotlight from OS provided by Apple. ![spotlightsynapse](/images/posts/2014/synapse-indicator-spotlight-for-ubuntu/spotlightsynapse.jpg) Synapse Indicator (AKA indicator-synapse) can be installed with the following commands:

```
sudo add-apt-repository ppa:noobslab/apps
sudo apt-get update
sudo apt-get install indicator-synapse
```

Drawback of Synapse Indicator is the fact that it does not have shortcut for search. We can set it by doing some "hack" described at [Nerd Answer](http://nerdanswer.com/answer.php?q=395661) page.

Adding keyboard shortcut for Synapse Indicator (hack)
-----------------------------------------------------

### Step 1: Install xdtool.

sudo apt-get install xdotool

### Step 2: Move your mouse over the synapse icon and get mouse location

xdotool getmouselocation

You should get output like this:

x:1568 y:9 screen:0 window:62914568

### Step 3: Add keyboard shortcut for indicator

Go to `System Settings -> Keyboard -> Shortcuts -> Custom Shortcuts`. Click add and for the command type (replace x and y with the ones from the previous command):

```
xdotool mousemove <x> <y> click 1 mousemove restore
```

Then add the shortcut you want. It's not pretty and elegant way, but I don't know any other solution. If you know, how to do it better, leave a comment, below this article.

### Additional note

Please remember that if you change your screen resolution or switch between two screens (e.g. laptop screen and external, bigger screen), your mouse click coordinates will have to be updated in the shortcut.
