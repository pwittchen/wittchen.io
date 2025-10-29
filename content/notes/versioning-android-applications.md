---
title: Versioning Android applications
date: 2014-09-13 12:49:00
tags:
- android
- gradle
- git
---

When we work in a team projects, our code constantly changes and being tested. Often some bugs occur in a specific version of application and no longer exists in next version of the project, because one programmer might fixed the bug according to the [Boy Scout Rule](http://programmer.97things.oreilly.com/wiki/index.php/The_Boy_Scout_Rule) and this is good. Nevertheless, sometimes we need to write documentation and check in which version bug occurred to be sure, that it was really fixed. In addition, [QA](http://en.wikipedia.org/wiki/Quality_assurance) Engineer needs to know, which version of the project he or she should check. That's why we should introduce versioning system to our project. In Android Manifest we have `versionCode` and `versionName`. The `versionCode` is used for updates on Google Play Store and it has to be integer value. We should increment `versionCode` before releasing new version of the application for the users. The `versionName` available in Android Manifest is a string value and we can use it to store information, which we need in a current project. When we use Git as a Version Control System, we can put SHA value of a specific commit into our version name. In addition, we can add date and time of compilation to this variable. After that, our `versionName` contains very detailed information about current version of our application. Exemplary `versionName` will look in as follows: `f935ea7-20140913144001`. We can obtain that with proper configuration of `build.gradle` file containing `buildTime()` method and `gitSha()` method. Please, take a look at creation of `versionName` in 35th line of the `build.gradle` file presented below.

```gradle
import java.text.SimpleDateFormat

def buildTime() {
    def df = new SimpleDateFormat("yyyyMMddHHmmss")
    df.setTimeZone(TimeZone.getTimeZone("Europe/Warsaw"))
    return df.format(new Date())
}

def gitSha() {
    return 'git rev-parse --short HEAD'.execute().text.trim()
}

apply plugin: 'android'
apply plugin: 'android-test'

android {
    packagingOptions {
        exclude 'LICENSE.txt'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/NOTICE.txt'
        exclude 'values/attrs.xml'
        exclude 'values/dimens.xml'
        exclude 'values/colors.xml'
    }

    compileSdkVersion 19
    buildToolsVersion "19.0.3"

    defaultConfig {
        minSdkVersion 14
        targetSdkVersion 19
        versionCode 1
        versionName gitSha() + '-' + buildTime()
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }
}
```
