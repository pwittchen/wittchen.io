---
title: Releasing prefser 2.0.0
date: 2015-08-06 22:34:00
tags:
- android
- open-source
---

I've recently released [Prefser](https://github.com/pwittchen/prefser) library v. [2.0.0](https://github.com/pwittchen/prefser/releases/tag/v2.0.0). Prefser is a wrapper for Android SharedPreferences with object serialization and RxJava Observables. This update couldn't be done without help of awesome open-source community and people who reported new issues and created pull requests. Thanks for that! A lot of issues related to RxJava was fixed. Moreover, now we can store and retrieve lists of objects of any type with Prefser. Examples of library usage can be found in `README.md` file and in unit tests covering 96% of the code. Below, you can find release notes for this version of the library:

*   fixed not keeping reference to listener when `Observable` instance is reused
*   fixed not unregistering listener, which causes `onNext()` even after `unsubscribe()`
*   fixed possible missed update with `getAndObserve()`
*   removed `observe(sharedPreferences)` method - _backward incompatible_
*   changed `observeDefaultPreferences()` method name to `observePreferences()` \- _backward incompatible_
*   added `TypeToken` and use of generics for interfaces
*   added possibility to store Lists of different types of data including custom objects
*   added more unit tests
*   updated test dependencies
*   updated JavaDoc available at [http://pwittchen.github.io/prefser/](http://pwittchen.github.io/prefser/)

Feel free to fork the project or report new issues! Any kind of feedback is warmly welcome.
