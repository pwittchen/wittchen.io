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

When we see response, that's ok

## System time and date initial setup

To perform system time and date initial setup, we need to run the following command:

```
timedatectl set-ntp true
```

## Partitions

### Removing existing partitions

...

### Creating new partitions

...

### Creating file systems

...

### Creating SWAP

...

### Mounting partitions

...

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
