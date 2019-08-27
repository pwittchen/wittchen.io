---
title: Formatting USB drive on Linux
tags:
    - linux
    - usb
    - drive
---

Sometimes we may want to format external USB drive. I recently encountered a situation, where I had bootable USB drive with operating system ready to install, but I wanted to remove all this stuff and use disk for storing data. I couldn't format this disk with GUI tools for some reason and I kept getting errors or information that it's not possible. In case you don't know, on Linux everything is always possible, so I quit that GUI garbage, opened terminal and start playing with good old and simple programs.

TBD.

todo: print real outputs

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

## References
- https://www.sinisterstuf.org/blog/345/renaming-usb-devices-in-linux
- https://www.cyberciti.biz/faq/linux-disk-format/
