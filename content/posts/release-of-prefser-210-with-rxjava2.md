---
title: Release of prefser v. 2.1.0 with RxJava2 support
date: 2017-06-19 16:56:00
tags:
- android
- open-source
- java
- rxjava
---

I've recently released new version of [prefser](https://github.com/pwittchen/prefser) library for Android. In case you don't know, it's a wrapper for Android SharedPreferences with object serialization and RxJava Observables. This version has the new artifact, which has codebase migrated to RxJava2.x. As usual, I kept backward compatibility with RxJava1.x. You can find more details about the project at [https://github.com/pwittchen/prefser](https://github.com/pwittchen/prefser). If you want to use it in your mobile project, you need the following dependencies in the `build.gradle` file:


```gradle
dependencies {
  compile 'com.github.pwittchen:prefser-rx2:2.1.0'
  compile 'io.reactivex:rxandroid:2.0.1'
}
```

Short release notes can be found at [https://github.com/pwittchen/prefser/releases](https://github.com/pwittchen/prefser/releases). This update was requested by at least two developers on GitHub and it's my second most popular project, so I hope you'll find it useful if you're in the process of migrating from RxJava1.x to RxJava2.x. I still have 4 remaining RxJava1.x libraries waiting for the upgrade. If you want to perform any updates via Pull Requests, you're more than welcome.
