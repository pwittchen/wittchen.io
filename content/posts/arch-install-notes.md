---
title: Arch Linux - installation notes
tags:
  - arch
  - linux
date: 2019-07-24 23:59:20
---


## Introduction

For a long time, I was considering switching from Ubuntu do Arch Linux distribution, but I didn't have enough knowledge, time and energy to do this. I definitely knew it requires some specific knowledge and manual steps to perform. I also didn't wat to spend too much time on reading the documentation. Moreover, I know that sometimes I could have specific issues related to my hardware, which are not listed in documentation and I have to deal with them on my own. Due to these facts I was discouraged to install Arch. Recently, I found awesome video about [Full Arch Linux Install](https://www.youtube.com/watch?v=4PBqpX0_UOc) by [Luke Smith](https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA) where everything is explained very clearly in each step. I watched it one time without doing anything and then, watched it next time performing all the steps described there. I had a few issues related to my hardware and BIOS, but I managed to install Arch on my ThinkPad T470s thanks to this video. During the installation, I made a few notes for myself for the future possible installations. Maybe you'll find them useful too. The whole process is actually simpler than I thought. It just requires some practical knowledge about Linux, patience and "can do" attitude. I divided this article into steps and sub-steps, which are required to perform the installation. Please, keep in mind the fact that in the end of the installation, we will have an empty command prompt with plain OS without any GUI and we will have to install the graphical environment from the terminal. It will not be covered in this article, but I think, I'll cover it in another one. Of course, this article contains just my notes, which help me understand everything well because and I like documenting this kind of things for the future. If you searching for Arch installation guide, I recommend you to see linked video or an [official Arch installation guide](https://wiki.archlinux.org/index.php/Installation_guide) in Arch Wiki. This article can be additional resource to this stuff.

## Booting installer from USB

### Creating bootable USB

In order to create bootable USB, we need to download `*.iso` file with Arch from https://www.archlinux.org/download/. We also need to have `dd` (disk dump) program installed. We need to invoke `lsblk` before inserting USB drive to see our drives and invoke `lsblk` again after inserting the USB drive to see, which one it is. We can also have a look at disk sizes, what helps in recognizing our disk. Next, we can call `dd`:

```bash
dd if=/path/to/arch.iso of=/dev/sdb status="progress"
```

`status="progress"` parameter will allow us to monitor progress of the whole process.

**Note**: please, be sure that you are writing on the correct disk! In the example above, we're writing to `/dev/sdb`. It may be the same in your case, but it may be different too! It's just an example!

### BIOS configuration

We need to go into the BIOS before installation. It may be different on different computers. On mine it's hitting <kbd>Enter</kbd> after reboot and then <kbd>F1</kbd>. Inside BIOS, we need to change order of booting devices and move USB drive to the top. I also had to disable secure boot and quick boot. Moreover I set `UEFI/Legacy Boot` to `Both` (`UEFI/Legacy Boot Priority`: `UEFI First`, `CSM Support`: `YES`). Sometimes network boot may interrupt boot process, so I set it to `USB HDD`. I had to play more with this stuff on freshly installed system because it was not booting in the beginning. It may be different on your computer. Sometimes, there may be no issue with it.

## First things

### UEFI check

Once we have booted installer from USB stick, we need to perform [UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) check as follows.

```
ls /sys/firmware/efivars
```

If it outputs an error or nothing, that's ok and we can proceed with installation. If you see bunch of files, then installation procedure may be different or may require additional steps.

### Internet check

We need to check an internet connection because we will need it to download packages. We can do it just by simple ping:

```
ping wittchen.io
```

When we see response, that's ok.

It's worth to mention, that it's good to have ethernet cable connection for the installation process. Optionally, you can use `wifi-menu` to connect wirelessly, but it's not recommended for the installation.

## System time and date initial setup

To perform system time and date initial setup, we need to run the following command:

```
timedatectl set-ntp true
```

## Partitions

Let's see what partitions do we have on our system. We can view them with `lsblk` program.

```
lsblk
```
Before we start doing anything, we should remove existing partitions. We can do it with `fdisk` tool by running it with our main disk as a parameter. Usually it will be `/dev/sda`, but in my case it was `/dev/nvme0n1`. We can get this name from `lsblk` output.

```
fdisk /dev/nvme0n1
```

### Removing existing partitions

Next, we can choose different options. In our case, we need to choose `:d` to delete partitions. We need to call this option for each partition.

Sometimes, we may have problems with installation or removing old partitions. In that case, we can use alternative method of cleaning disk:

```
sgdisk --zap-all /dev/nvme0n1p1
```

### Creating new partitions

Now, we have to prepare our disk for the future system installation. Our goal is to have the following configuration of the partitions

```
nvme0n1     259:0    0   477G  0 disk
├─nvme0n1p1 259:1    0   200M  0 part /boot
├─nvme0n1p2 259:2    0    24G  0 part [SWAP]
├─nvme0n1p3 259:3    0    25G  0 part /
└─nvme0n1p4 259:4    0 427,8G  0 part /home
```

This is the output from my current system and `nvme0n1` is the disk. First partition (`nvme0n1p1`) is `boot` partition used during the system boot. Next partition (`nvme0n1p2`) is a SWAP partition, which acts as an overflow for our RAM memory, when it gets filled up. Third partition (`nvme0n1p3`) is root partition, which is the root of the file system and programs will be installed there. The last partition (`nvme0n1p4`) is home partition, where we are going to keep our files.

In order to create new partition, we have to call `fdisk /dev/nvme0n1p1` (if we haven't done it yet).
Let's create boot partition. Type `:c` for create. We leave first sector empty, hit <kbd>Enter</kbd> in the last sector we put `+200M` for 200 megabytes, which is recommended value for boot partitoin and confirm it with <kbd>Enter</kbd>. We follow this procedure for SWAP, which should have size = `1.5 * size of RAM in computer`. I currently have 16GB of RAM, so it's `1.5 * 16 GB = 24 GB`, so I put `+24G` in the last sector. Next, we can create root partition. It should have around `+25G`. You can decrease it if you have small disk or increase it if you have huge disk and plans to install a lot of programs. In the end, we are creating home partition, where in the last sector option we can just hit <kbd>Enter</kbd> and `fdisk` will assign remaining disk space to this partition. When we're done, we should confirm our partition configuration with `:w` like write. Then, we can type `lsblk` again to see our written configuration. It should look like in the example above.

### Creating file systems

Next, we can to create file systems on our partitions. In general, we can use `ext4`, which is Linux file system. Some devices may have boot problems or may have specific BIOS setup. In that case, it's recommended to use `FAT32` file system. Let's use `mkfs` program to create file systems.

We will create `FAT32` file system on our boot partition:

```
mkfs.vfat -F32 /dev/nvme0n1p1
```

Then, we will create `ext4` file systems on root and home partitions:

```
mkfs.ext4 /dev/nvme0n1p3
mkfs.ext4 /dev/nvme0n1p4
```

### Creating SWAP

Now, we can create SWAP on the `nvme0n1p2` partition:

```
mkswap /dev/nvme0n1p2
```

Next, we can turn the SWAP on:

```
swapon /dev/nvme0n1p2
```

### Mounting partitions

Right now, we are ready to mount our partitions.

We can mount the root partition as follows:

```
mount /dev/nvme0n1p3 /mnt
```

When we list this partition:

```
ls /mnt
```

we should see `lost+found` file, which is a generic system file.

Now on the root partition we can create home and boot directories.

```
mkdir /mnt/home
mkdir /mnt/boot
```

and mount our previously created partitions into these dirs:

```
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p4 /mnt/home
```

and then we can type `lsblk` to see that everything is created properly.

## Arch installation

Now, there is an easy part. We have everything prepared and we're ready to install the operating system.

Arch can be installed with literally **one command**:

```
pacstrap /mnt base
```

It's recommended to install `base-devel` package, which contains additional software, which may be required to run everything. We can also install `vim`, to have an editor to edit our configs and other stuff. The final command can look like this:

```
pacstrap /mnt base base-devel vim
```

## Creating fstab

We should also create `fstab` file, which contains information about system drives and mounted partitions and file systems.
We can do it as follows:

```
genfstab -U /mnt >> /mnt/etc/fstab
```

My `/etc/fstab` file looks like that:

```
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/nvme0n1p3
UUID=d94887d0-daff-4a4b-a28a-1de3fdadbb58/         ext4      rw,relatime0 1

# /dev/nvme0n1p1
UUID=97B8-B124      /boot     vfat      rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro0 2

# /dev/nvme0n1p4
UUID=75b24330-5ca7-47fc-a6ea-3d4cd826df4d/home     ext4      rw,relatime0 2

# /dev/nvme0n1p2
UUID=2788826f-9abf-44c7-b2d5-15323be8ba4enone      swap      defaults  0 0
```

## Operations inside the system

### Changing root

Now, we can change the root:

```
arch-chroot /mnt
```

After typing command above, we jumped from the bootable USB drive into the operating system installed on the disk of our computer.

Now, we're able to perform operations inside the system.

### Installing network manager

First of all, we should install network manger via `pacman` to have network and Internet connectivity:

```
pacman -S networkmanager
```

to enable network manager, we can type:

```
systemctl enable NetworkManager
```

### Installing GRUB

We also have to install GRUB, which will be responsible for booting our operating system:

```
pacman -S grub
```

Next, we have to configure it:

```
grub-install --target=i386-pc /dev/nvme0n1
```

Please note, we provided path to the disk (drive) - not the partition.

Next, we should create `/boot/grub/grub.cfg` configuration file:

```
grub-mkconfig -o /boot/grub/grub.cfg
```

### Setting password

to set the password, we can just type:

```
passwd
```

### Setting locale

To set locale, we need to edit `/etc/locale.gen` (e.g. via vim) and uncomment desired locales (one or more).

In my case I uncommented:

```
pl_PL.UTF-8
pl_PL ISO-8859-2
en_US.UTF-8
en_US ISO-88591
```

becasue I wanted to use both Polish and English language.

Now, we can type:

```
locale-gen
```

To set default locale, we have to edit `/etc/locale.conf` and set `LANG` variable as follows:

```
LANG=en_US.UTF-8
```

Of course, we can set `pl_PL.UTF-8` too or any other language we want to use as default system language. I personally use English as a OS language, bacause it's easier to diagnose possible issues, when you have English messages in terminal. Nevertheles, I use Polish as an input language, to be able to use Polish letters, european metric system, Polish currency, etc. It should be adjusted to our needs.

### Setting timezone

You can browse time zones in `/usr/share/zoneinfo` directory. To set our time zone, we need to create a symbolic lin between desired time zone and `/etc/localtime` file. Once we change our time zone, we can create a symbolic link again.

```
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
```

My time zone is Warsaw in Europe, but you can set your own time zone here.

### Setting hostname

To create our `hostname`, which is name of the computer, we can edit `/etc/hostname` file and put our name there.

My hostname is `arch`.

## Finalization

### Unmounting file systems

Before we reboot our computer, we should unmount partitions:

```
umount -R /mnt
```

### Rebooting

To reboot computer, we can just type:

```
reboot
```

## What's next?

Once, our computer will be restarted, GRUB should boot our operating system and we should see the black screen with white letters and command prompt. It means, everything went fine, our system is installed and booted! Now, we're ready to install other sutff (e.g. Desktop Environment or Window Manager). We can also leave it without GUI, if our computer has really low specs or when we're planning to use this machine as a server or something like that.

## Summary

To wrap up, installing Arch is not trivial and requires some proficiency with Linux and terminal. Neverhteless, once you have some basics, it's no that hard as we can expect. In addition, we have great documentation and resources on the web about it. Going through this process can be nice lesson. You can see, how much stuff automatic installers are doing for us. Moreover, we can totally adjust system to our needs. We don't need to have a bloat of not necessary packages and programs like we have on Ubuntu. We can install exactly what we need and track our packages. I haven't mentioned it before, but Arch has rolling release system. It means, there are no huge system updates like in Ubuntu, Windows or macOS. We can gradually update our system by installing small amount of single packages and our system can be up to date basically everyday. I'm using Arch for a few weeks for now and it seems to be one of the best and most stable operating systems I have used so far. It's quite hard to break something on this system until you explicitly break it (e.g. by typing into terminal commands you don't understand). It's also light-weight and customizable. I cannot recommend this system to people who are not familiar with Linux, don't like to play with computers and software, don't want to fix stuff for themselves, customize system etc., but if you're are not in this group, this OS may be for you.
