---
title: Gnome Classic desktop environment on Ubuntu
date: 2015-08-23 01:02:00
tags:
	- ubuntu
	- linux
	- gnome
---

Introduction
------------

I was tired of non-minimal and quite slow Unity desktop environment. Of course, I performed a few tricks to [make Unity faster](http://blog.wittchen.biz.pl/making-ubuntu-and-unity-faster/), but still I wasn't satisfied enough. I checked out different desktop environments. I wanted to have clean, minimal and productive environment. I like top panel from Unity as well as HUD and many workspaces. The last thing is quite common among different desktop environments.

New desktop environment
-----------------------

I decided to choose [Gnome](https://www.gnome.org/) classic. It's fast, clean, minimal, works easily with Ubuntu, has top panel and is configurable. My current desktop looks like this: 

![screenfetch-2015-08-18-11_00_51](/images/posts/2015/gnome-classic-ubuntu/screenfetch-2015-08-18-11_00_51-1024x576.png)

Unfortunately, I don't have HUD like in Unity, but after a few days I got used to that. I also turned off all animations and visual effects. Everything works smoothly and looks much better than Unity. In the current configuration I have: [Z Shell](https://en.wikipedia.org/wiki/Z_shell), [Oh-my-zsh](http://ohmyz.sh/), [dmenu](http://tools.suckless.org/dmenu/), [Numix](https://numixproject.org/) Theme and [Numix](https://numixproject.org/) Circle Icons. In addition, I have the same [indicators](http://blog.wittchen.biz.pl/indicators-for-ubuntu/), which I had earlier on Unity and they work fine. I just needed to [adjust look of Spotify icon](https://github.com/pwittchen/dotfiles/tree/master/install/icons/spotify) in top panel. Moreover, [Gnome Pie](http://simmesimme.github.io/gnome-pie.html) was installed later as additional launcher and media controller.

Installation of Gnome Classic and Numix Theme
---------------------------------------------

I've installed Gnome Classic as follows:

sudo apt-get install gnome-session-fallback

Then, I installed Gnome Tweak Tool and Unity Tweak Tool:

sudo apt-get install gnome-tweak-tool unity-tweak-tool

and Compiz Config Manager with plugins:

sudo apt-get install compizconfig-settings-manager compiz-plugins-extra

**Please note**: to enable alt+tab in gnome classic fallback, open the manager and navigate to window management and check application switcher (previously disabled). After that I could install Numix icons and theme:

sudo add-apt-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install numix-gtk-theme numix-icon-theme numix-icon-theme-circle

I've set appropriate theme and icons via Gnome Tweak Tool. After reboot of the computer changes should be successfully applied.

Detailed information about configuration
----------------------------------------

If you're interested in detailed configuration information, you can check out my _dotfiles_ at: [https://github.com/pwittchen/dotfiles](https://github.com/pwittchen/dotfiles) and system configuration at: [https://github.com/pwittchen/ubuntu-config](https://github.com/pwittchen/ubuntu-config). To generate system information for the screenshot I used [screenfetch](https://github.com/KittyKatt/screenFetch) script. I didn't worked correctly for `gnome-session-fallback`, but I've made [small contribution on GitHub](https://github.com/KittyKatt/screenFetch/commit/1c5a2c798e82e810d8e962a1540f5428f77540d6) and now it's fine.

Wallpaper
---------

You can find wallpaper from the screenshot at [papers.co](http://papers.co/ac08-wallpaper-triangle-art-blue-rainbow-illust-graphic/) website.

Alternatives & Resources
------------------------

I've spent some time on analyzing alternative desktop environments and Linux based operating systems, which looks good. Below, you can find my collection of information and resources. Maybe some of them will be better for your specific needs. **Interesting Reddit channels**:

*   [https://www.reddit.com/r/unixporn](https://www.reddit.com/r/unixporn)
*   [https://www.reddit.com/r/linuxmasterrace](https://www.reddit.com/r/linuxmasterrace)
*   [https://www.reddit.com/r/linux](https://www.reddit.com/r/linux)

**Selected Linux based systems with interesting user interface**:

*   [Solus Project](https://solus-project.com) (formely Evolve OS)
*   [Ozon OS](http://ozonos.github.io/)
*   [Elementary OS Freya](https://elementary.io/)

**Selected Linux window managers**:

*   [Unity](https://unity.ubuntu.com/)
*   [KDE](https://www.kde.org/)
*   [Gnome](https://www.gnome.org/)
*   [Xfce](http://www.xfce.org/)
*   [Budgie](https://solus-project.com/budgie/) (from Solus Project)
*   [Elementary OS](https://elementary.io/)
*   [i3](https://i3wm.org/)

Recap
-----

After switching from Unity to Gnome my desktop is much more better, faster and cleaner. After mastering popular shortcuts for managing programs, windows, workspaces, etc. we can work very efficiently. Gnome Classic is fine for me right now, but maybe other WM will be better for you. It depends on your personal preferences. I'm gonna use Gnome Classic for some time and maybe I'll try other environments in the future. For sure I won't go back to Unity if it don't evolve.