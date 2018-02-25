---
layout: posts
title: Unit Testing Support for Android Studio 1.1
date: 2015-02-15 12:53:00
tags:
	- android
---

As official Android website says:

> Version 1.1 of Android Studio and the Android gradle plugin brings support for unit testing your code. This feature is still considered experimental, we encourage you to try it and file any bugs you find in our bug tracker.

It's great news, because now we can write Unit Tests with JUnit 4.12 without any "hacks" or tricky configuration, which had to be done earlier. We can execute two kinds of tests:

*   **Unit Tests** - pure Java tests without Android dependencies written in JUnit, which can be run in Android Studio or CLI via Gradle without emulator or attached device. These tests have to be located in: `/src/test/java/` directory.
*   **Android Instrumentation Tests** - tests for code, which have dependencies to Android Context or Android API and have to be executed on Android emulator or physical device like phone or tablet. These tests have to be located in: `/src/androidTest/java/` directory.

Read more at: [http://tools.android.com/tech-docs/unit-testing-support](http://tools.android.com/tech-docs/unit-testing-support) and check Gradle Plugin User Guide: [http://tools.android.com/tech-docs/new-build-system/user-guide](http://tools.android.com/tech-docs/new-build-system/user-guide)
