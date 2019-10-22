---
title: Fixing Gnome Boot problem
tags:
  - linux
  - arch
  - gnome
date: 2019-10-22 22:42:21
---


I recently had an issue with Gnome on Arch Linux during the system boot. After turning my computer on, I saw gray screen with message like:

```
Oh no! Something has gone wrong. A problem has occurred and the system can't recover...
```

and I couldn't log in or do anything and started searching solutions for this problem via my phone. First, I switched to terminal mode with <kbd>Alt+F2</kbd> (you can switch back to GUI with <kbd>Alt+F1</kbd>), logged in and updated system via pacman: `sudo pacman -Syu`. I tried to install or reinstall different packages mostly related to graphic card drivers, X11 or Gnome, but it didn't help. Luckily, I found [this thread](https://bbs.archlinux.org/viewtopic.php?id=203416) on the Arch Forums, where there was [a post](https://bbs.archlinux.org/viewtopic.php?pid=1568684#p1568684) suggesting disabling [Wayland](https://en.wikipedia.org/wiki/Wayland_%28display_server_protocol%29) on [GDM](https://wiki.gnome.org/Projects/GDM) by opening `/etc/gdm/custom.conf` file and uncommenting line with

```
WaylandEnable=false
```

I did that. After restart, it finally fixed this problem and Gnome was loaded succesfully. That was the first time I had an issue with Boot related to Gnome and Arch. Fortunately, thanks to good community, I was able to fix it pretty quickly (in ~30 minutes) and avoided system re-installation. After that, I also had a few issues with sound on Bluetooth devices, but I fixed them quickly too.

I hope, you'll find this post useful in case of having similar problems.
