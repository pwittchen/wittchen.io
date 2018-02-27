---
title: Bunch of updates in my OSS for Android
date: 2015-11-08 16:53:00
tags:
	- android
	- open-source
---

Introduction
------------

In the last days I prepared a bunch of updates in my open-source software for Android. Most of them are bug fixes and are related to increasing robustness of the projects as well as their overall quality. I also decided to play a little with [Kotlin](https://kotlinlang.org/) language from JetBrains, which seems to be reasonable choice for mobile applications running on Android. Nevertheless, writing an app in Kotlin requires some additional configuration and we should remember, it's still in beta version. If you are interested in Kotlin programming for Android, take a look at [Getting started with Android and Kotlin](https://kotlinlang.org/docs/tutorials/kotlin-android.html) guide from official Kotlin website. You can also take a look at [one of my sample apps](https://github.com/pwittchen/ReactiveNetwork/tree/master/app-kotlin) written in Kotlin and [its configuration in Gradle](https://github.com/pwittchen/ReactiveNetwork/blob/master/app-kotlin/build.gradle).

Summary of updates
------------------

### [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) v. 0.1.3

*   fixed bug with incorrect status after going back from background inside the sample app reported in issue [#31](https://github.com/pwittchen/ReactiveNetwork/issues/31)
*   fixed RxJava usage in sample app
*   fixed RxJava usage in code snippets in `README.md`
*   added static code analysis
*   updated code formatting
*   added sample [sample app in Kotlin](https://github.com/pwittchen/ReactiveNetwork/tree/master/app-kotlin)

Unfortunately, in Android we cannot use Java 8 yet and code should be written in Java 7. We can do some hacks like using RetroLambda or libraries implementing part of functionalities available in Java 8 like streams, but these solutions are still hacks - not the right way. In Kotlin we can use lambdas like in Java 8. In addition, we have a lot of other cool features, which allow us to write less lines of code and detect possible mistakes while writing apps. E.g. Kotlin helps us to avoid NPEs with its additional operators like `!!`, which tells us that NPE can occur, so we can think of eliminating this possibility. If we don't use this operator when we should, IntelliJ IDEA or Android Studio will warn us. Below, we can see exemplary usage of ReactiveNetwork library with Kotlin. In this code snippet, we are using so called _synthetic properties_ from [Kotlin Extensions for Android](https://kotlinlang.org/docs/tutorials/android-plugin.html). Value `connectivity_status` is an id of the view defined in XML layout. We can call it directly in Kotlin code and treat as object. It's really useful and allows us to avoid calling `findViewById(...)` method for every view in Activity or injecting views with additional libraries like ButterKnife or KotterKnife. It means that we can get rid of a lot of boilerplate code.

### [ReactiveSensors](https://github.com/pwittchen/ReactiveSensors)

*   fixed RxJava usage in sample app
*   fixed RxJava usage in code snippets in `README.md`
*   added static code analysis
*   refactored sample app and removed repetitions in code

In this project I made only changes inside the documentation, improved Gradle configuration and added another sample app. There were no changes inside the library code, so there was no need to release new library version to Maven Central Repository. Moreover, I'm going to add sample app in Kotlin for this project in the nearest future.

### [ReactiveBeacons](https://github.com/pwittchen/ReactiveBeacons) v. 0.3.0

*   replaced `distinct()` operator with `distinctUntilChanged()` operator in `Observable observe()` method in `ReactiveBeacons` class
*   added permissions `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` to satisfy requirements of Android 6
*   renamed `void requestBluetoothAccessIfDisabled(activity)` method to `void requestBluetoothAccess(activity)`
*   added `boolean isBluetoothEnabled()` method
*   added `boolean isLocationEnabled(context)` method
*   added `void requestLocationAccess(activity)` method
*   modified sample app in order to make it work on Android 6 Marshmallow
*   reduced target API from 23 to 22 in library due to problems with additional permissions and new permission model (it can be subject of improvements in the next releases)
*   added package private `AccessRequester` class
*   added [sample app in Kotlin](https://github.com/pwittchen/ReactiveBeacons/tree/master/app-kotlin)

### [WeatherIconView](https://github.com/pwittchen/WeatherIconView) v. 1.1.0

*   added icons from 2.0 version of the original [weather-icons project](https://github.com/erikflowers/weather-icons/)
*   updated compile sdk version
*   updated Gradle Build Tools version

### [Prefser](https://github.com/pwittchen/prefser) v. 2.0.2

*   fixed bug reported in issue [#70](https://github.com/pwittchen/prefser/issues/70): `get(...)` method now returns a `null` value instead of "null" string when setting default value to null of String type
*   fixed RxJava usage in sample app
*   fixed RxJava usage in code snippets in `README.md`
*   changed code formatting to `SquareAndroid`
*   added static code analysis
*   improved code according to static code analysis suggestions

### [Kirai](https://github.com/pwittchen/kirai) v. 1.1.0

*   removed `formatter(...)` method from `Kirai` class
*   added `format(...)` method accepting implementation of `Formatter` interface to `Kirai` class
*   added `Syntax` interface and `HtmlSyntax` class implementing this interface
*   added `put(String key, Object value, Syntax syntax)` method to `Piece` class
*   set `HtmlSyntax` as default `Syntax` implementation in `Piece` class
*   removed dependencies to Android SDK
*   updated project dependencies
*   applied `Square` code style
*   updated tests, sample app and code snippets in `README.md`
*   added gh-pages with JavaDoc

Any suggestions of further improvements are more than welcome as usual!
