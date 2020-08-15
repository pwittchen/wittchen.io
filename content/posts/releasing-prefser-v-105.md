---
title: Releasing prefser v. 1.0.5
date: 2015-06-18 20:46:00
tags:
- android
- open-source
---

I am happy to announce that I released version 1.0.5 of [Prefser](https://github.com/pwittchen/prefser) Android library. Prefser is a wrapper for Android SharedPreferences with object serialization and RxJava Observables. What has been done in this version:

*   Removed `final` keyword from `Prefser` class in order to allow class mocking thanks to [@plackemacher](https://github.com/plackemacher)
*   Removed unused imports from `Prefser` class
*   Added [test coverage report generation](http://blog.wittchen.biz.pl/test-coverage-report-for-android-application/)
*   [Increased test coverage to 100%](http://pwittchen.github.io/prefser/test-coverage-report)
*   Added abstraction for `JsonConverter` and default `GsonConverter`
*   Added `getAndObserve(...)` method
*   Emiting current value right on subscription to `Observable` with `getAndObserve(...)` method, which is idea provided by [@semanticer](https://github.com/semanticer). Thanks!
*   Added GitHub pages with generated JavaDoc documentation on `gh-pages` branch available at: [http://pwittchen.github.io/prefser](http://pwittchen.github.io/prefser)

Moreover you can browse auto-generated reports:

*   latest test report at: [http://pwittchen.github.io/prefser/test-report](http://pwittchen.github.io/prefser/test-report)
*   latest test coverage report at: [http://pwittchen.github.io/prefser/test-coverage-report](http://pwittchen.github.io/prefser/test-coverage-report)

Some improvements wouldn't be implemented without engagement of the open-source community on GitHub, so thanks for reporting your issues and providing suggestions! I am always open for improvements in my projects. You can get new version of the library, its source code, download instructions and documentation at: [https://github.com/pwittchen/prefser](https://github.com/pwittchen/prefser)
