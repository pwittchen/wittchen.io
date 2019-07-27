---
title: Arch Linux - installation notes no. 2 (GUI and utils)
tags:
  - arch
  - linux
  - gnome
date: 2019-07-27 09:31:30
---


## Introduction

In my [previous article](/arch-install-notes) I roughly described Arch Linux installation process. After going through whole process, we will end up with clean terminal without any graphical environment etc. In most cases, we will need it on the desktop.

## Desktop Environment (DE) / Windows Manager (WM)

There are two main types of the Linux graphical environments for desktop:
- Window Managers
- Desktop Environments

Window Managers are much simpler, require a lot of configuration, learning how to use them and you see all windows at once. Moreover, usually you can use them without a mouse and mouse is useless most of the time because you cannot drag and drop windows. Once you master it, working with Window Manager can be very efficient. Example of popular Window Manager is [i3](https://i3wm.org/). This environments are also lightweight. On the other hand, we have Desktop Environments. They're full of features, windows can be stacked one on another and you can drag and drop them. Several Desktop Environments are extensible through plugins. These kind of graphical interfaces are known to majority of computer users. You can see them on Windows or macOS. Examples of the popular Linux Desktop Environments are [Gnome](https://www.gnome.org/), [Xfce](https://xfce.org/) and [KDE](https://kde.org/). Of course, mentioned Window Managers and Desktop Environments are not the only avaiable. There are more. I just mentioned these because I've heard about them or tried them.

I'm using Gnome Desktop Environment right now, so I will show you how to install it in this article

### Installing X Window System

X Window system is a GUI component created in 80s at MIT. One of the most popular implementation of X is X.org, which we're going to install. Gnome is built on top of X that's why, we're installing X first.

To install X Window system, we can type:

```
sudo pacman -S xorg-server xorg-xinit xorg-server-utils
```

To install desktop features, we can type:

```
sudo pacman -S xorg-twm xorg-xclock xterm
```

Now, we can start X Window system, in which we will install Gnome

```
startx
```

### Installing Gnome

Let's install required fonts:

```
sudo pacman -S ttf-dejavu
```

Now, we're ready to install Gnome:

```
sudo pacman -S gnome
```

Enable the display manager:

```
 sudo systemctl enable gdm.service
```

Now, we can reboot our system and once computer restarts, we should see Gnome GUI

```
reboot
```

## Sound

Sound is usually not enabled by default on Arch and we need to install required software:

```
sudo pacman -S alsa-utils
```

`alsa-utils` package is recommended for this task

We can type `alsamixer` to view and adjust the configuration.

We can also test our speaker with `speaker-test -c 2` command or via Gnome GUI.

Once we're done, it's good to reboot the computer. 

Sometimes it may be required to perform additional configuration depending on our type of computer or specific sound devices.

## Bluetooth

If we're using Bluetooth mouse, keyboard, headphones or speaker, we should install appropriate Bluetooth software:

```
pacman -S pulseaudio-bluetooth
```

Now, we should enable `bluetooth.service`:

```
systemctl enable bluetooth.service
```

You can connect Bluetooth Device via `bluetoothctl` or via Gnome GUI.

```
bluetoothctl
[bluetooth] power on
[bluetooth] agent on
[bluetooth] scan on
[NEW] Device [MAC address]
[bluetooth] pair [MAC address]
[bluetooth] connect [MAC address]
```

Please note, that devices won't connect automatically after turning the computer on. In order to achieve that, we should mark them as trusted.

```
bluetoothctl
[bluetooth] trust [MAC address]
```

We should perform the same procedure for all our Bluetooth devices.

After next reboot, our devices should connect automatically before login.

## Other packages 

Things mentioned above are necessary for running regular desktop environment. Other stuff should be adjusted to our needs. We should keep in mind the fact that Arch is minimalistic distro and it shouldn't be polluted by too many packages. We should install only what we need. Once we're are not using a specified program, it's good to remove it. We should read more about `pacman`, which is Arch package manager. It allows us to install packages, update and manage them. In order to update our whole operating system and its packages, we can type:

```
sudo pacman -Syuw
```

That's one of the many pacman features. We can install new packages calling `pacman` with `-S` parameter:

```
sudo pacman -S package
```

It's also good to remember that, we can use [aur](https://aur.archlinux.org/) repository, which provides third-party packages from users and vendors in case we want to install a specific kind of software. While playing with aur, I was tired of repatitive tasks, so I created (yet another) simple aur helper available here: https://github.com/pwittchen/aur.sh, which you can use. Please note, it doesn't resolve package dependencies yet.

## Summary

Now, we have prepared simple, basic and clean desktop environment. From this point, we can proceed with the further adjustments and customizations (or leave it as it is :-). In the past I worked with Windows, macOS and Ubuntu Linux and personally I think I like Arch Linux distribution with such setup the most. I can control everything, I know what is working under the hood and how it's configured, I have installed only software packages I really need, updates are seamless and everything just works. It's really hard to break anything on this system if you know what you're doing. Moreover, documentation and community are great. Of course, it requires some learning and time in the beginning, but if you're working with computers or like playing with them, in my opinion it's time well invested because Linux knowledge can be our great asset at work or in daily usage of the computer.
