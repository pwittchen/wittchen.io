---
title: Mockito on Android
date: 2015-03-15 15:44:00
tags:
	- android
	- mockito
	- testing
---

Overview
--------

When we write unit tests for an Android application, sometimes there's a necessity to mock some classes or interfaces. Instead of writing implementations dedicated for unit tests by hand, we can use Mockito library. We can read article about [Mockito on Android](https://corner.squareup.com/2012/10/mockito-android.html) on [Square's blog](https://corner.squareup.com/). Mockito can make our tests cleaner and better. It can be used both in _classic_ Java projects and Android projects. It's one of the most popular mocking framework in Java and if you're a Java developer who writes unit tests and tries to apply TDD approach, you should be familiar with it.

Sample configuration
--------------------

When we want to use Mockito on Android, we have to remember to add dependency to `dexmaker 1.0` and `dexmaker-mockito 1.0`. Sample test configuration in `build.gradle` file can look as follows (I've added more comments to clarify optional doubts):

```gradle
dependencies {
    // our project dependencies go here...

    androidTestCompile 'com.android.support.test:testing-support-lib:0.1' // Android testing support library
    androidTestCompile('com.google.truth:truth:0.25') { // Google's library for assertions (not required by Mockito)
        exclude group: 'junit' // Android has JUnit built in
    }
    androidTestCompile 'com.google.dexmaker:dexmaker:1.0' // required by Mockito
    androidTestCompile 'com.google.dexmaker:dexmaker-mockito:1.0' // required by Mockito
    androidTestCompile 'org.mockito:mockito-core:1.9.5'
}
```

We should also add information about `tesInstrumentationRunner` to `build.gradle` file when we are using it. When we have problems with running our tests, we should configure `packagingOptions` properly.

```gradle
android {
    defaultConfig {
        ...
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
    }
    packagingOptions {
        exclude 'LICENSE.txt'
        exclude 'META-INF/LICENSE.txt'
    }
}
```

Remember
--------

Quotation from [Mockito website](http://mockito.org/):

*   Do not mock types you don’t own
*   Don’t mock value objects
*   Don’t mock everything
*   Show love with your tests!

References
----------

*   [Mockito website](http://mockito.org/) (includes instructions, examples and documentation)
*   [Main reference documentation](http://site.mockito.org/mockito/docs/current/org/mockito/Mockito.html) (with more examples)
*   [Mockito on GitHub](https://github.com/mockito/mockito)
*   [Mockito on Google Code](https://code.google.com/p/mockito/) (please note: Google Code is closing soon!)
*   [Mockito on Android](https://corner.squareup.com/2012/10/mockito-android.html) (Square's blog)
