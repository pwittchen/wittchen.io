---
title: Formatting USB drive on Linux
tags:
    - linux
    - usb
    - drive
---

TBD.

```
lsblk
sudo fdisk -l
sudo fisk /dev/sdc
d
n
w
sudo mkfs.vfat /dev/sdc1
sudo umount /dev/sdc1
sudo mlabel -i /dev/sdc1 ::mydisk
```
