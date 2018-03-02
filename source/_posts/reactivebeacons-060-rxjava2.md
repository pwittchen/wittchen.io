---
title: ReactiveBeacons - release of v. 0.6.0 with support for RxJava2
date: 2017-04-03 18:20:00
tags:
	- android
	- open-source
	- bluetooth
	- ble
---

Thanks to [@BugsBunnyBR](https://github.com/BugsBunnyBR) I released new version of [ReactiveBeacons](https://github.com/pwittchen/ReactiveBeacons) library with the RxJava2.x support. It's an Android library scanning BLE (Bluetooth Low Energy) beacons nearby with RxJava Observables. I also kept backward compatibility with RxJava1.x. Different versions of the libraries are located on the separate git branches. It's a similar approach to original [RxJava](https://github.com/ReactiveX/RxJava) project. I have separate builds on Travis CI, separate artifacts and JavaDocs. Such approach generates more overhead, but in such case, RxJava1.x can be kept in a maintenance mode and RxJava2.x can be a subject of the future development. What has been done in this version?

*   migrated library to RxJava2.x on RxJava2.x branch and released it as `reactivebeacons-rx2` artifact
*   kept library compatible with RxJava1.x on a RxJava1.x branch and released it as `reactivebeacons` artifact
*   removed master branch
*   bumped library dependencies
*   added permission annotations
*   organized Gradle configuration
*   transformed instrumentation unit tests to pure java unit tests
*   started executing unit tests on Travis CI server
*   created separate JavaDoc for RxJava1.x and RxJava2.x

If you want to add RxJava2.x version to your Android project, add the following dependency to `build.gradle` file:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivebeacons-rx2:0.6.0'
}
```

For RxJava1.x you can use old artifact id:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivebeacons:0.6.0'
}
```

This library was one of the first experiments with my migrations to RxJava2.x. I have plans to migrate rest of my libraries soon. Thanks to the awesome open-source community on GitHub, this process goes faster and I don't have to do everything by myself.