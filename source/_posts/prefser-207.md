---
title: Releasing Prefser v. 2.0.7
date: 2017-05-28 20:48:00
tags:
	- android
	- java
	- open-source
---

I've recently released new version of [Prefser](https://github.com/pwittchen/prefser). It's a wrapper for Android SharedPreferences with object serialization and RxJava Observables. The new version number is [2.0.7](https://github.com/pwittchen/prefser/releases/tag/v2.0.7). In this release, I performed mostly internal work not related to the external library API. Nevertheless, it's important for the library development in the future. The following things were done:

*   updated dependencies
*   updated Gradle configuration
*   migrated unit tests to Robolectric
*   started executing unit tests on Travis CI
*   added integration with codecov.io and coverage report
*   extracted code related to accessors from the Prefser class (refactoring library internals)

Organizational work is done and now I'm ready for migration to RxJava2 in this project on a separate branch. I want to keep backward compatibility with RxJava1 as in my other projects. This update is planned for version 2.1.0. Stay tuned!