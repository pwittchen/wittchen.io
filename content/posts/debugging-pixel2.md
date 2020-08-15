---
title: Debugging Google Pixel 2
tags:
  - android
date: 2018-06-20 23:05:56
---


I recently destroyed my good old Nexus 6 phone. It's still working, but display screen is broken. Due to this fact, I've had an excuse to buy new Pixel 2 phone. It's pretty expansive, but its quality is really good. As usual, I wanted to debug an app on this device and encountered problem related to device permissions. 

Once I connected the phone, to my laptop and typed `adb devices`, I've seen the following message:

```
List of devices attached
HT7AS1A03004    no permissions (user in plugdev group; are your udev rules wrong?); see [http://developer.android.com/tools/device.html]
```

and I couldn't debug my apps.

Later, I enabled debugging in:

```
Settings -> System -> Developer Options -> USB Debugging
```

Of course, in order to see these options, we need to tap several times on the compilation number first in:

```
Settings -> System -> Information about the phone
```

After that, debug options will be enabled

Nevertheless, I still couldn't debug my apps!

I realized, I have connected phone just for charging

![](/posts/2018/debugging-pixel2/pixel2_usb_screenshot.png)

Once, I switched it to "Transfer files", I could finally debug my phone.

It's important to note, that it's good to restart `adb` (Android Debug Bridge) after changing connection mode to avoid any further problems.

We can do this as follows:

```
adb kill-server
adb start-server
```

Now, we should see the following message:

```
* daemon not running; starting now at tcp:5037
* daemon started successfully
```

Next, we can type `adb devices` again and we see that our device is finally attached.

```
List of devices attached
HT7AS1A03004    device
```

Now, we can install our apps or run logcat with `adb logcat` command or even more fancy colored [pidcat](https://github.com/JakeWharton/pidcat) if we want to.

I hope, you will find this post useful in case of having similar issues.
