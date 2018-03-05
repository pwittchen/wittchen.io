---
title: Releasing ReactiveNetwork v. 0.11.0
date: 2017-08-06 06:38:00
tags:
	- android
	- java
	- open-source
---

In the latest release of [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) library, I focused on [Walled Garden](http://searchsecurity.techtarget.com/definition/walled-garden) AKA Great Firewall support during checking Internet connectivity. There are countries with limited Internet access like China and in such cases, pinging commonly known host like www.google.com may have different results than in other countries because it may be blocked. We may get false positive results because users will generally have an access to the Internet, but they don't have access only to several websites. To solve that problem, I created [WalledGardenInternetObservingStrategy](https://github.com/pwittchen/ReactiveNetwork/blob/RxJava2.x/library/src/main/java/com/github/pwittchen/reactivenetwork/library/rx2/internet/observing/strategy/WalledGardenInternetObservingStrategy.java) and made it default strategy for checking Internet connectivity inside the library. Of course, you can still use [SocketInternetObservingStrategy](https://github.com/pwittchen/ReactiveNetwork/blob/RxJava2.x/library/src/main/java/com/github/pwittchen/reactivenetwork/library/rx2/internet/observing/strategy/SocketInternetObservingStrategy.java) if you want to. Detailed release notes are as follows: **RxJava1.x**

*   added `WalledGardenInternetObservingStrategy` \- fixes [#116](https://github.com/pwittchen/ReactiveNetwork/issues/116)
*   made `WalledGardenInternetObservingStrategy` a default strategy for checking Internet connectivity
*   added documentation for `NetworkObservingStrategy` \- solves [#197](https://github.com/pwittchen/ReactiveNetwork/issues/197)
*   added documentation for `InternetObservingStrategy` \- solves [#198](https://github.com/pwittchen/ReactiveNetwork/issues/198)
*   bumped Kotlin version to 1.1.3-2
*   bumped Gradle Android Tools version to 2.3.3
*   bumped Retrolambda to 3.7.0

**RxJava2.x**

*   added `WalledGardenInternetObservingStrategy` \- fixes [#116](https://github.com/pwittchen/ReactiveNetwork/issues/116)
*   made `WalledGardenInternetObservingStrategy` a default strategy for checking Internet connectivity
*   added documentation for `NetworkObservingStrategy` \- solves [#197](https://github.com/pwittchen/ReactiveNetwork/issues/197)
*   added documentation for `InternetObservingStrategy` \- solves [#198](https://github.com/pwittchen/ReactiveNetwork/issues/198)
*   fixed package name in `AndroidManifest.xml` file - solves [#195](https://github.com/pwittchen/ReactiveNetwork/issues/195)
*   bumped RxJava2 version to 2.1.2
*   bumped Kotlin version to 1.1.3-2
*   bumped Gradle Android Tools version to 2.3.3
*   bumped Retrolambda to 3.7.0
*   increased code coverage with unit tests

Repository address: [https://github.com/pwittchen/ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). 

Happy coding!
