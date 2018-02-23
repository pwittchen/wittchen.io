---
title: How to connect to Android device via TCP/IP? 
date: 2013-10-12 12:48:00
tags:
    - android
    - tcpip
---

While developing Android applications, we need to debug them on real devices. We also should be able to access [debug output](http://developer.android.com/tools/help/logcat.html) and execute Unix shell commands. In Android device (mobile phone or tablet), we can go to _Settings_ and then to _Developer options_. Afterwards, we can enable _USB Debugging_. Now, we can connect our device via USB cable to the computer and we will be able to access it via [Android Debug Bridge (ADB)](http://developer.android.com/tools/help/adb.html). USB connection is standard way of debugging application on real devices. We can also use TCP/IP connection and debug applications wireless. In order to do that, we need to go through the following steps:

1.  Activate USB debug mode in Android device (it's described above)
2.  Connect Android device to computer via USB
3.  Open command prompt (With Admin Right) and type: _**adb tcpip 5555**_ (note #1: in Windows OS, you need to have _platform-tools_ directory from Android SDK directory assigned to system variable _Path_; note #2: 5555 is number of port we will be using)
4.  Disconnect your tablet or smartphone from computer
5.  Open command prompt type: _**adb connect IPADDRESS**_ (_IPADDRESS_ is the DHCP/IP address of your tablet or smartphone, which you can find by going to: _Settings_ » _About device_ » _Status_ » _IP address_)

Now, you can use [adb commands](http://developer.android.com/tools/help/adb.html#commandsummary). E.g. _adb shell_ or _adb logcat_. If you want to list connected devices or check if any device is connected to your computer, you can use command: _adb devices_. 

**Note #1**: You shouldn't use TCP/IP and USB debugging mode at the same time. If you want to return to USB debugging mode, just connect your device to the computer via TCP/IP and then type: _**adb usb**_. After that, connect device to the computer via USB cable and you will be able to debug applications via USB connection again. 

**Note #2**: In Android Studio you can use built-in terminal window instead of standard command prompt. 

**Note #3**: Alternative way of returning to default debug mode (USB) is resetting the phone. You can simply turn it off and then turn it on and device will be in USB debug mode again.
