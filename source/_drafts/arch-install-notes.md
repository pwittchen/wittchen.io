---
title: Arch Linux - install notes
tags:
    - arch
    - linux
    - install
---

## Introduction

...

## Booting installer from USB

### Creating bootable USB

In order to create bootable USB, we need to download `*.iso` file with Arch from https://www.archlinux.org/download/. We also need to have `dd` (disk dump) program installed.
We need to invoke `lsblk` before inserting USB drive to see our drives and invoke `lsblk` again after instertin the USB drive to see, which one it is. We can also have a look at disk sizes, what helps in recognizing our disk. Next, we can call `dd`:

```bash
dd if=/path/to/arch.iso of=/dev/sdb status="progress"
```

**Note**: please, be sure that you are writing on the correct disk! In the example above, we're writing to `/dev/sdb`. It may be the same in your case, but **it may be different too**! It's just an example.

### BIOS configuration

...

## First things

### UEFI check

...

### Internet check

...

## System time and date initial setup

...

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
