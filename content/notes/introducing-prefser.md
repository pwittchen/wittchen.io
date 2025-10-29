---
title: Introducing prefser
date: 2015-02-22 22:39:00
tags:
- android
- java
- open-source
---

I've recently released [Prefser](https://github.com/pwittchen/prefser), which is a wrapper for Android [SharedPreferences](http://developer.android.com/reference/android/content/SharedPreferences.html) with object serialization and [RxJava](https://github.com/ReactiveX/RxJava) Observables. Prefser wraps SharedPreferences and thanks to Java Generics provides you simpler API than classic SharedPreferences with only two methods:

```java
void put(String key, Object value);
<T> T get(String key, Class classOfT, T defaultValue);
```

Classic SharedPreferences allows you to store only primitive data types and set of strings. Thanks to [Gson](https://code.google.com/p/google-gson/) serialization, Prefser allows you to store:

*   Primitive data types (boolean, float, int, long, double)
*   Strings
*   Custom Objects
*   Lists
*   Arrays
*   Sets

In addition, Prefser transforms [OnSharedPreferenceChangeListener](http://developer.android.com/reference/android/content/SharedPreferences.OnSharedPreferenceChangeListener.html) into Observables from RxJava:

Observable<String> observe(final SharedPreferences sharedPreferences);
Observable<String> observeDefaultPreferences();

You can [subscribe one of these Observables](https://github.com/pwittchen/prefser#subscribing-for-data-updates) and monitor updates of SharedPreferences with powerful RxJava. Moreover, you can [observe single preference](https://github.com/pwittchen/prefser#reading-data-from-observables) under a specified key with the following method:

<T> Observable<T> observe(final String key, final Class classOfT, final T defaultValue)

![prefser_observable_diagram](/posts/2015/introducing-prefser/prefser_observable_diagram.png)

For more details, examples and download instructions visit GitHub webiste of the project at: 

[https://github.com/pwittchen/prefser](https://github.com/pwittchen/prefser)

I've provided sample app using Prefeser in this repository, which you can check to get familiar with the project. Library is open source, has [Unit Tests](https://github.com/pwittchen/prefser/blob/master/library/src/androidTest/java/com/github/pwittchen/prefser/library/PrefserTest.java), [Travis CI job](https://travis-ci.org/pwittchen/prefser) and is available on Maven Central Repository. You can depend on it through Maven or Gradle.
