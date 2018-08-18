---
title: Writing my first library in Kotlin
tags:
    - java
    - kotlin
    - android
---

## Introduction

Recently, I decided to create a tiny Android library called [RxBattery](https://github.com/pwittchen/RxBattery), which is monitoring battery state of the device with RxJava and RxKotlin. I created a few Java and Android libraries already and this time I decided to use [Kotlin](https://kotlinlang.org/) programming language instead of Java to learn something new and write something more complicated than "Hello World" app. Here are my observations.

## Build System

I used Gradle to build the project. It's popular for all JVM and Android apps nowadays and works fine with Kotlin. I just needed to add Kotlin Gradle Plugin and Kotlin STD Lib to the `build.gradle` file to the `classpath` dependencies in `buildscript` section. I also needed to define `sourceSets` to allow IntelliJ and Android Studio recognize directories with sources.

```groovy
android {
  sourceSets {
    androidTest.java.srcDirs += "src/androidTest/kotlin"
    main.java.srcDirs += "src/main/kotlin"
    test.java.srcDirs += "src/test/kotlin"
  }
}
```

## Static Code Analysis

...

## Kotlin vs. Java

...

## Unit Tests

...

## JavaDoc

...

## Library Deployment

...

## Summary

...
