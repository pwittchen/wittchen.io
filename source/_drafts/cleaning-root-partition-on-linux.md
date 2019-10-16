---
title: Cleaning root partition on Linux
tags:
    - linux
---

Size of the root partition `/` on my system is 25 GB. I recently had a situation where I received notification from the system that there's too little free space on that partition, which was around 1 GB. My first attempt was to clean pacman cache with `sudo pacman -Sc`. It helped for a moment, but I kept receiving this notification. I searched for the solutions regarding extending the root partition and noticed that it wouldn't be that easy and probably require making backup and reinstalling the system. Although installing Arch is not scary for me anymore, I didn't want to do that again, because it takes some time and after that I will have to configure all my stuff, install apps, etc. which is a lot of work. Due to this fact I started search for the solutions about cleaning root partition. I found nice program called `ncdu`, which is abbreviation for NCurses Disk Usage according to the man page. You can install it with pacman: `sudo pacman -S ncdu`. This program shows usage of the directories and shows directories, which takes the biggest amount of space on the disk. Once you have that program, you can go to the root partition and run it:

```
cd /
ncdu
```

It will do the analysis and return an interactive output with directories, size and visualisation of the size:


```
-- / -------------------------
. 99,8 GiB  [##########] /home
.  12,1 GiB [#         ] /usr
.   7,8 GiB [          ] /var
. 689,2 MiB [          ] /opt
. 191,4 MiB [          ] /tmp
   55,0 MiB [          ] /boot
.  11,3 MiB [          ] /etc
.   1,8 MiB [          ] /run
. 912,0 KiB [          ] /dev
!  16,0 KiB [          ] /lost+found
   12,0 KiB [          ] /srv
!   4,0 KiB [          ] /root
e   4,0 KiB [          ] /mnt
.   0,0   B [          ] /proc
.   0,0   B [          ] /sys
@   0,0   B [          ]  snap
@   0,0   B [          ]  sbin
@   0,0   B [          ]  lib64
@   0,0   B [          ]  lib
@   0,0   B [          ]  bin
```

We can naviagte through this directories and locate places which takes space on disk, which can be free.

For example, here are the contents of the `/usr/` directory:

```
--- /usr ------------------------

.   5,9 GiB [##########] /share
    5,2 GiB [########  ] /lib
  816,9 MiB [#         ] /bin
  279,8 MiB [          ] /include
   15,5 MiB [          ] /local
   13,1 MiB [          ] /src
    5,5 MiB [          ] /lib32
    2,5 MiB [          ] /doc
@   0,0   B [          ]  sbin
@   0,0   B [          ]  lib64
```

I've noticed that there were logs in `/var/log/journal/`, which have significant size. I also had a lot of downloaded packages in `/var/cache/pacman/`. As I noticed `pacman -Sc` command don't clean all the caches and keeps the newest packages, so if we want to remove everything or almost everything, we can configure pacman appropriately or remove packages manually. These data could be cleaned and saved me a few GB of space, so I stopped seeing notification. During cleanup, we can also have a look at other cache data, logs and `/tmp/` directory. To verify disk sizes and used space, we can use `df -H` command.

I hope, you'll find this tips useful and avoid resizing root partition or system re-installation.
