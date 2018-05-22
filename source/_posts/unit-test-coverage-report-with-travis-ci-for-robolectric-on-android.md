---
title: Unit test coverage report with Travis CI for Robolectric on Android
date: 2017-03-19 19:32:00
tags:
	- android
	- testing
	- coverage
	- robolectric
	- travis
---

Introduction
------------

Some time ago, I've written an article about [Test coverage report for Android application](/2015/06/03/test-coverage-in-android-applications/). It got some interest (many comments below article and many visits according to Google Analytics), so I decided to refresh this topic. Previously, I've written instrumentation unit tests, which needed to be executed on a real device or an emulator. It's a good approach when you want to test functionalities strongly connected with the device. E.g. when you want to test operations on a real SQLite database or something like that. Nevertheless, this approach has huge disadvantages. It's hard to run tests on the Continous Integration server because we need to have the emulator or device up & connected all the time and also tests need to interact properly with the device to get passed what is not so easy. In most cases, mocking part of the application's behavior is enough. In that case, we can easily run tests on a CI server and have deterministic test results. In order to do that, we can use [**Robolectric**](http://robolectric.org/).

Gradle configuration
--------------------

First, we have to add appropriate dependency to `jacoco-android` plugin in our top-level `build.gradle` file:

```gradle
buildscript {
  repositories {
    jcenter()
  }
  dependencies {
    classpath 'com.android.tools.build:gradle:2.3.0'
    classpath 'com.dicedmelon.gradle:jacoco-android:0.1.1'
  }
}
```

Next, we need to add appropriate test dependencies in another `build.gradle` file for our app or library.

```gradle
dependencies {
  testCompile 'junit:junit:4.12'
  testCompile 'com.google.truth:truth:0.32'
  testCompile 'org.robolectric:robolectric:3.1.2'
  testCompile 'org.mockito:mockito-core:2.7.17'
}
```

I've added also dependencies to JUnit, Truth and Mockito library, which are used in my tests. We also need to add appropriate plugins:

```gradle
apply plugin: 'jacoco'
apply plugin: 'jacoco-android'

To avoid ignoring our tests by the coverage report, we need to configure the following settings:

android {
  testOptions {
    unitTests.all {
      jacoco {
        includeNoLocationClasses = true
      }
    }
  }
}
```

Next, we need to configure report output:

```gradle
jacocoAndroidUnitTestReport {
  csv.enabled false
  html.enabled true
  xml.enabled true
}
```

Travis CI configuration
-----------------------

We are done with Gradle configuration. I'm assuming we have Travis CI build configured. If you don't know, how to do this, visit [travis-ci.org](http://travis-ci.org) and enable builds for your project. It' pretty easy. Now, we should visit [codecov.io](http://codecov.io) website, register there (e.g. with GitHub account) and add our project. After that, we need to add the following items to our `.travis.yml` file:

```
after_success:
  - bash <(curl -s https://codecov.io/bash)

script:
  - ./gradlew clean build test jacocoTestReport check
```

Here we are performing clean, build an application, running unit tests, generating test coverage report with Jacoco and performing check (Lint, FindBugs, PMD & CheckStyle).

Writing unit tests with Robolectric
-----------------------------------

Next we can place our tests in `src/test/` directory. 

Sample unit test can look as follows: 

```java
@RunWith(RobolectricTestRunner.class) @Config(constants = BuildConfig.class)
public class MyUnitTests {
    @Test public void myValueShouldBeTrue() {
      boolean myValue = true;
      assertThat(myValue).isTrue();
    }
}
```

In my case, I also needed to create `src/test/resources/robolectric.properties` file with the following content:

```
sdk=23
```

because Robolectric didn't work with the Android SDK newer than 23. Moreover, I also needed to use Robolectric v. `3.1.2`, because I had problems with running tests and generating coverage report with the latest version of the Robolectric.

Summary
-------

When we have everything configured, we can push our tests to the GitHub repository, Travis CI build will be triggered and we can beautiful test coverage report, which can help to improve our tests. 

![](/images/posts/2017/test-coverage-android-travis/codecovio-report-1.png)

We can also click on the main package and see detailed coverage information for the several packages. 

![](/images/posts/2017/test-coverage-android-travis/codecovio-report-2.png)

Moreover, we can analyze coverage change in time. 

![](/images/posts/2017/test-coverage-android-travis/codecovio-report-3.png)

I've applied approach described in this article in [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) open-source library. 

If want to see the complete solution, take a look at the source code of this project or see [its coverage report on-line](https://codecov.io/gh/pwittchen/ReactiveNetwork).
