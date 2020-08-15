---
layout: posts
title: NetworkEvents v. 1.0.2
date: 2015-02-15 00:16:00
tags:
- android
- open-source
---

I've recently released [NetworkEvents](https://github.com/pwittchen/NetworkEvents) v. 1.0.2. In case, you don't know it, it's an Android library listening network connection state and change of the Wifi signal strength. This version has small improvements:

*   Updated `ping` method in `NetworkHelper` class.
*   Detection of Internet access in WiFi network works faster and is more reliable.
*   Added example of usage of NetworkEvents with [Dagger](https://github.com/square/dagger) in `example-dagger` directory in the repository of the project.

Right now, we check Internet connection in a different way. Instead of sending HEAD or GET request to a specific website like www.google.com, we just ping 4.2.2.2 IP address. If you want to know why, read an article about [4.2.2.2: The Story Behind a DNS Legend](http://www.tummy.com/articles/famous-dns-server/). 

Check new version of the project on GitHub: [https://github.com/pwittchen/NetworkEvents](https://github.com/pwittchen/NetworkEvents) 