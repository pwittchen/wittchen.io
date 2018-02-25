---
title: Making Ubuntu faster
date: 2015-03-28 16:43:00
tags:
	- ubuntu
	- linux
---

Unity desktop environment consumes lot of computer's memory. I've recently found good article about [4 simple tweaks to improve Unity performance on Ubuntu](http://www.techdrivein.com/2013/03/4-simple-tweaks-to-improve-unity-performance-ubuntu.html). Here is the short summary of that tweaks:

Remove Unwanted Lenses
----------------------

It will speed up loading data under "Super" button. 

```
sudo apt-get autoremove unity-lens-music unity-lens-photos unity-lens-gwibber unity-lens-shopping unity-lens-video
```

Install Compiz Config Settings Manager
--------------------------------------

```
sudo apt-get install compizconfig-settings-manager
```

In Compiz Config Settings Manager perform the following operations:

* Disable Animations and Fading windows
* Set the Texture Filter to "Fast"

After that OS won't use additional resources for performing animations.

Install Preload
---------------

```
sudo apt-get install preload
```

Preload analyzes applications, which are currently used and predicts, which applications might be used. After proper analysis, it loads to memory commonly used software. That process can drastically boost speed of loading programs and overall Ubuntu performance.
