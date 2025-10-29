---
title: Releasing NetworkEvents 2.0.0
date: 2015-07-31 09:28:00
tags:
- android
- open-source
---

I've recently released [NetworkEvents](https://github.com/pwittchen/NetworkEvents) library [v. 2.0.0](https://github.com/pwittchen/NetworkEvents/releases/tag/v2.0.0). It's an Android library listening network connection state and change of the Wifi signal strength. It has a few significant changes in the API and new features, which people were requesting on GitHub. Moreover, codebase was slightly refactored and updated. I'm going to keep `major.minor.patch` convention AKA semantic versioning now:

*   **major** \- new feature or update - backward incompatible
*   **minor** \- new feature - backward compatible
*   **patch** \- bug-fix - backward compatible

A few changes are backward incompatible, so I've increased `major` number. Below, you can find list of changes. As you can see, there is a lot of stuff. That's why I've made the most important changes **bold**.

*   removed `withPingUrl(url)` method
*   removed `withPingTimeout()` method
*   removed `withoutPing()` method
*   removed `withoutWifiAccessPointsScan()` method
*   **removed Otto dependency (now, it's available only for unit tests)**
*   removed `example-disabling-ping-and-wifi-scan` app sample
*   removed `example-ping-customization` app sample
*   **removed `NetworkHelper` class and moved its method to specific classes with changed scope**
*   **moved permissions to Manifest of library**
*   **disabled WiFi scan by default**
*   **disabled Internet connection check by default**
*   **added `BusWrapper`, which is abstraction for Event Bus required by NetworkEvents object**
*   **added example-greenrobot-bus app sample**
*   added `enableWifiScan()` method
*   added `enableInternetCheck()` method
*   added `getWifiScanResults()` method in WifiSignalStrengthChanged event
*   added `getMobileNetworkType()` method in ConnectivityChanged event
*   added JavaDoc at: [http://pwittchen.github.io/NetworkEvents/](http://pwittchen.github.io/NetworkEvents/)
*   updated existing sample applications
*   updated documentation in `README.md` and library code

Feel free to [download](https://github.com/pwittchen/NetworkEvents#download), use or fork this library!