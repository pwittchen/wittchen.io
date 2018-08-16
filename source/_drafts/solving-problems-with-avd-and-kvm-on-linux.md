---
title: Solving problems with AVD and KVM on Linux
tags:
    - android
    - linux
---

I installed Android SDK and Android Studio on my new ThinkPad T470s with Ubuntu Linux 18.04.1 LTS. As usual, I wanted to create a new Android phone emulator called AVD (Android Virtual Device). I was able to create a new device, but unfortunately I encoutered problems. After opening AVD window, I saw the error message...

## /dev/kvm is not found

KVM (for Kernel-based Virtual Machine) is a full virtualization solution for Linux on x86 hardware containing virtualization extensions (Intel VT or AMD-V). In order to enable KVM, I needed to restart the computer and enter the BIOS by pressing `F1` key. Next, I entered `Security` tab and enabled Intel Virtualization Technology and Intel VT-d Feature. Now, I could press `F10` to save, exit nad restart the computer. Unfortunately, that wasn't the end of the story. I saw another message...

## /dev/kvm device permission denied

Luckily, I found answer to this issue on [StackOverflow](https://stackoverflow.com/questions/37300811/android-studio-dev-kvm-device-permission-denied$). I just needed to install `qemu-kvm` and add my user to the `kvm` group.

I installed required software:

```
sudo apt install qemu-kvm
```

Then, checked the ownership of `/dev/kvm`:

```
ls -al /dev/kvm
```

The user was root, the group kvm. To check which users are in the kvm group, use

```
grep kvm /etc/group
```

This returned

```
kvm:x:some_number:
```

As there is nothing left to the final `:`, there are no users in the kvm group.

To add the user `username` to the kvm group, we could use:

```
sudo adduser username kvm
```

which adds the user to the group.

We can check our `username`, by typing:

```
whoami
```

check group members once again with:

```
grep kvm /etc/group
```

Our user should be there. Next, just restart the machine, create new AVD, start it and everything works!

## References
- https://stackoverflow.com/questions/36527278/dev-kvm-not-found-error-on-windows-in-android-studio
- https://stackoverflow.com/questions/37300811/android-studio-dev-kvm-device-permission-denied
- https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine
