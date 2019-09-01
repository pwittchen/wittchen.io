---
title: Formatting USB disk on Linux
tags:
    - linux
    - usb
    - drive
---

Sometimes we may want to format external USB drive. I recently encountered a situation, where I had bootable USB drive with operating system ready to install, but I wanted to remove all this stuff and use disk for storing data. I couldn't format this disk with GUI tools for some reason and I kept getting errors or information that it's not possible. In case you don't know, on Linux everything is always possible, so I quit that GUI tool, opened terminal and start playing with good old and simple programs.

When we insert disk and type:

```
lsblk
```

we can see the output:

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0         7:0    0 181,1M  1 loop /var/lib/snapd/snap/spotify/36
loop1         7:1    0 147,3M  1 loop /var/lib/snapd/snap/skype/66
loop2         7:2    0  88,5M  1 loop /var/lib/snapd/snap/core/7270
loop3         7:3    0   236M  1 loop /var/lib/snapd/snap/kde-frameworks-5/27
loop4         7:4    0 180,2M  1 loop /var/lib/snapd/snap/spotify/35
loop5         7:5    0 149,6M  1 loop /var/lib/snapd/snap/slack/16
sdb           8:16   1   7,5G  0 disk
└─sdb1        8:17   1   7,5G  0 part /run/media/pw/DISK3
nvme0n1     259:0    0   477G  0 disk
├─nvme0n1p1 259:1    0   200M  0 part /boot
├─nvme0n1p2 259:2    0    24G  0 part [SWAP]
├─nvme0n1p3 259:3    0    25G  0 part /
└─nvme0n1p4 259:4    0 427,8G  0 part /home
```

When we type:

```
sudo fdisk -l
```

we'll see:

```
...

Disk /dev/sdb: 7,51 GiB, 8053063680 bytes, 15728640 sectors
Disk model: USB DISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x40a863e7

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdb1        2048 15728639 15726592  7,5G 83 Linux
```

Now, we have basic information about our USB drive. It's located in `/dev/sdb` and has `7,5 GB` of space.
Sometimes, we can have mulitple partitions on our drive. In such case, we may want to delete them and create new partition.

To do that, we can type:

```
fdisk /dev/sdb
```

next, we can use `d` for deleting partition:

```
Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): d
Selected partition 1
Partition 1 has been deleted.
```

and `n` for creating a new one:

```
Command (m for help): n
Partition type
p   primary (0 primary, 0 extended, 4 free)
e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-15728639, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-15728639, default 15728639):

Created a new partition 1 of type 'Linux' and of size 7,5 GiB.
Partition #1 contains a vfat signature.

Do you want to remove the signature? [Y]es/[N]o: Y

The signature will be removed by a write command.
```

after that, we can confirm the process with `w` command:

```
Command (m for help): w
The partition table has been altered.
Syncing disks.
```

next, we can umount drive:

```
sudo umount /dev/sdb
```

and create a file system - in our case, we'll use FAT32 file system in order to make USB drive accessible across all operating systems

```
sudo mkfs.vfat /dev/sdb1
```

after that, we can create a label for our disk with name `disk3` (it can be anything):

```
sudo mlabel - /dev/sdb1 ::disk3
```

Please note, when we create file system of a different type, we need to use different commands for creating disk labels. For more information about that, read article about [renaming USB devices on Linux](https://www.sinisterstuf.org/blog/345/renaming-usb-devices-in-linux).

That's it! Maybe it's not that easy as clicking on the GUI, but we can see whole process and format any disk even when something seems to be messed up.

## References
- https://www.sinisterstuf.org/blog/345/renaming-usb-devices-in-linux
- https://www.cyberciti.biz/faq/linux-disk-format/
