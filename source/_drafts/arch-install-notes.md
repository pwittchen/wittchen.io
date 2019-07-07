---
title: Arch Linux - install notes
tags:
    - arch
    - linux
    - install
---

## Introduction

For a long time, I was considering switching from Ubuntu do Arch Linux distribution, but I didn't have enough knowledge, time and energy to do this. I definitely knew it requires some specific knowledge and manual steps to perform. I also didn't wat to spend too much time on reading the documentation. Moreover, I know that sometimes I could have specific issues related to my hardware, which are not listed in documentation and I have to deal with them on my own. Due to these facts I was discouraged to install Arch. Recently, I found awesome video about [Full Arch Linux Install](https://www.youtube.com/watch?v=4PBqpX0_UOc) by [Luke Smith](https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA) where everything is explained very clearly in each step. I watched it one time without doing anything and then, watched it next time performing all the steps described there. I had a few issues related to my hardware and BIOS, but I managed to install Arch on my ThinkPad T470s thanks to this video. During the installation, I made a few notes for myself for the future possible installations. Maybe you'll find them useful too. The whole process is actually simpler than I thought. It just requires some practical knowledge about Linux, patience and "can do" attitude. I divided this article into steps and sub-steps, which are required to perform the installation. Please, keep in mind the fact that in the end of the installation, we will have an empty command prompt with plain OS without any GUI and we will have to install the graphical environment from the terminal. It will not be covered in this article, but I think, I'll cover it in another one.

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

Once we have booted installer from USB stick, we need to perform [UEFI](https://pl.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) check as follows.

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
swap on /dev/nvme0n1p2
```

### Mounting partitions

Right now, we are ready to mount our partitions.

## Operations inside the system

### Changing root

...

### Installing network manager

...

### Installing GRUB

...

### Setting password

...

### Setting locale

...

### Setting timezone

...

## Finalization

### Unmounting file systems

...

### Rebooting

...

## What's next?

...

## Summary

...
