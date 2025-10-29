---
title: New release of Kirai - elegant string formatting library for Java
date: 2015-11-22 20:34:00
tags:
- android
- java
- open-source
---

I've recently released version **1.4.0** of [Kirai](https://github.com/pwittchen/kirai) library. Kirai means _phrase_ in Swahili language. It's string formatting library written in Java. It originally started as an Android library, but it evolved to pure Java library. It's first possibilities were basic string formatting and text formatting for Android TextViews. Now, it allows to format strings for **Java**, **Web**, **Android** and even **Unix Terminal**! Have you ever wanted to have colorful and styled text in your mobile app, website or terminal app? Now you can with an elegant and fluent API! Moreover, I've added test coverage supported by [codecov.io](http://codecov.io). It's really nice service, which integrates with [Travis CI](http://travis-ci.org) and is free for open-source projects. It's available for various programming languages and build systems. Check library source code and samples at: [https://github.com/pwittchen/kirai](https://github.com/pwittchen/kirai).

You can add it to your project via Maven:

```xml
<dependency>
    <groupId>com.github.pwittchen.kirai</groupId>
    <artifactId>library</artifactId>
    <version>1.4.0</version>
</dependency>
```

or through Gradle:

```gradle
dependencies {
  compile 'com.github.pwittchen.kirai:library:1.4.0'
}
```
