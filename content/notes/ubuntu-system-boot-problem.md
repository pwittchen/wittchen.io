---
title: Ubuntu system boot problem
date: 2014-08-17 20:05:00
tags:
- ubuntu
- linux
---

Description of the problem
--------------------------

Recently, after installing Linux Ubuntu 14.04 LTS on my computer, I encountered strange problem during the system boot. Before system launched, I received the following message: After that, I typed: `exit` and system started normally, but this error occurred every time after reboot, so I decided to fix it.

Fixing the problem
------------------

### Attempt #1

First, I tried to change `rootdelay` as error message said. I opened file `/etc/default/grub` 
I found there the following line: 

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

and changed it to: 

```
GRUB_CMDLINE_LINUX_DEFAULT="rootdelay=90 quiet splash"
```

`rootdelay` became longer, but unfortunately it didn't fix the problem in my case.

### Attempt #2

I edited `/etc/fstab` file. I executed the following command in terminal: `sudo gedit /etc/fstab` and edited `fstab` file in _gedit_. In the beginning my file looked like that: 

```
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda1 during installation
UUID=96889309-5f73-4688-8354-e64cd1bb158f /               ext4    errors=remount-ro 0       1
# swap was on /dev/sda5 during installation
UUID=480cc3f7-a39d-4d0f-93d5-49fc8df1a392 none swap sw 0 0
```

Then, I commented one line and added another one describing `/dev/sda1` disk device. Now, my file looks as follows: 

```
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda1 during installation
UUID=/dev/sda1/               ext4    errors=remount-ro 0       1
# UUID=96889309-5f73-4688-8354-e64cd1bb158f /               ext4    errors=remount-ro 0       1
# swap was on /dev/sda5 during installation
UUID=480cc3f7-a39d-4d0f-93d5-49fc8df1a392 none swap sw 0 0
```

Problem still existed, so I tried another attempt to solve it.

### Attempt #3

I opened terminal and typed the following command: 

```
sudo grub-install /dev/sda
```

and then I typed another command to update [grub](http://en.wikipedia.org/wiki/GNU_GRUB "GNU GRand Unified Bootloader"): 

```
sudo update-grub
```

After all of this, I rebooted computer and finally, error disappeared and problem was **fixed**! 

**Note #1** 

After removing `rootdelay` from the `/etc/default/grub` file, everything still works fine. 

I was struggling with this error for some time, so I am very happy that I managed to fix it. I am a Linux n00b, so If you know any better or more efficient solutions to fix it, I will appreciate all of these. 

**Note #2** 

I've found another attempt (work-around) for this problem. You can get rid of the described problem with the following commands. 

```
sudo sed -i 's/maybe_break mount/sleep 5\nmaybe_break mount/g' /usr/share/initramfs-tools/init
sudo update-initramfs -u
```

For more details check [this thread](http://superuser.com/questions/527190/gave-up-waiting-for-root-device-ubuntu-12-04lts).
