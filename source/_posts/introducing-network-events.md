---
title: Introducing NetworkEvents
date: 2015-01-31 20:35:00
tags:
	- android
	- java
	- open-source
---

I have released NetworkEvents library for Android. It's a wrapper for system Broadcast Receivers built with Otto library. It allows you to listen change of connectivity status (connected to WiFi network with or without Internet access, mobile network, off-line) and change of the WiFi signal strength very easily with `@Subscribe` annotation. The only thing you need to do, is to create `Bus` and `NetworkEvents` objects, register them in `onResume()` method and unregister them in `onPause()` method in your activity. After that, you can subscribe for the events you want to listen. Of course, remember to give your app appropriate permissions in `AndroidManifest.xml` file. In contrast to Broadcast Receivers available in Android SDK, NetworkEvents sends only one event per one occurrence of this event. Android Broadcast Receivers have a [bug, which causes sending multiple Intents](http://stackoverflow.com/questions/8412714/broadcastreceiver-receives-multiple-identical-messages-for-one-event) even if only one event occurred. This behavior may vary on different devices. Regardless of this fact, this bug was handled by NetworkEvents and you shouldn't encounter that problem while using this library. Important facts:

*   Minimum Android SDK version required by the library is API 9 (Android 2.3 - GINGERBREAD) or above.
*   Latest version of the library is 1.0.1.
*   Library is available in Maven Central Repository and you can depend on it in your project via Maven or Gradle.
*   Project is open source and available on GitHub.
*   Library has Apache 2.0 License.

For more details, usage and download instructions, visit website of the project at [https://github.com/pwittchen/NetworkEvents](https://github.com/pwittchen/NetworkEvents). Feel free to fork it! If you found any bug or have an idea for improvements, don't hesitate and create an issue or pull request.
