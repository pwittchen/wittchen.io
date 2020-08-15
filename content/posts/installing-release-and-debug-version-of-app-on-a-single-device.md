---
title: Installing release and debug version of app on a single device
date: 2014-12-25 15:15:00
tags:
- android
- gradle
---

Introduction
------------

During software development process developers and QAs may want to have installed release and debug version of the app on a single device, what can be very helpful when they want to develop and use application at the same time. Another advantage is the fact that debug and release version of the app may need different configuration. It this post I will show you an example in which we are changing application name and launcher icon, but we can also change different values during compilation in the same way (e.g. address of the webservice). Some time ago, I've created [similar template](http://blog.wittchen.biz.pl/different-back-end-urls-for-debug-and-release-version-of-the-android-app/), but it was using older version of Build Tools, Android SDK and Android Studio. I've created new template, with the newest version of Android Studio (1.0.2) and newest version of Build Tools (1.0.0), so in that case, build.gradle file is smaller and simpler, but does its work correctly.

Exemplary repository
--------------------

You can find exemplary project template at: [https://github.com/FutureProcessing/android-debug-release-template](https://github.com/FutureProcessing/android-debug-release-template). All important information are included in [README.md](https://github.com/FutureProcessing/android-debug-release-template/blob/master/README.md) file and [build.gradle](https://github.com/FutureProcessing/android-debug-release-template/blob/master/app/build.gradle) file with project configuration. **Important files**:

*   [README.md](https://github.com/FutureProcessing/android-debug-release-template/blob/master/README.md)
*   [build.gradle](https://github.com/FutureProcessing/android-debug-release-template/blob/master/build.gradle)
*   [app/build.gradle](https://github.com/FutureProcessing/android-debug-release-template/blob/master/app/build.gradle)

Source of essential **[build.gradle](https://github.com/FutureProcessing/android-debug-release-template/blob/master/app/build.gradle)** file presenting main idea is as follows:

```gradle
import java.text.SimpleDateFormat

apply plugin: 'com.android.application'

android {
    compileSdkVersion 21
    buildToolsVersion "21.1.1"

    def appNameRelease = "My app"
    def appNameDebug = "My app debug"
    def launcherIconRelease = "@drawable/ic_launcher"
    def launcherIconDebug = "@drawable/ic_launcher_debug"

    signingConfigs {
        releaseConfig {
            storeFile file("../key/android-debug-release-template.jks")
            storePassword "SamplePassword1234"
            keyAlias "android-debug-release-template"
            keyPassword "SamplePassword1234"
        }
    }

    defaultConfig {
        applicationId "fp.com.debugreleasetemplate"
        minSdkVersion 14
        targetSdkVersion 21
        versionCode 1
        versionName gitSha() + '-' + buildTime()
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    buildTypes {
        debug {
            applicationIdSuffix '.debug'
            versionNameSuffix '-DEBUG'
            resValue "string", "app_name", appNameDebug
        }

        release {
            resValue "string", "app_name", appNameRelease
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.releaseConfig
        }
    }

    android.applicationVariants.all { variant ->
        variant.outputs.each { output ->
            output.processManifest.doLast {
                if (variant.buildType.isDebuggable()) {
                    def manifestOutFile = output.processManifest.manifestOutputFile
                    def newFileContents = manifestOutFile.getText('UTF-8').replace(launcherIconRelease, launcherIconDebug)
                    manifestOutFile.write(newFileContents, 'UTF-8')
                }
            }
        }
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile 'com.android.support:appcompat-v7:21.0.2'
}

def buildTime() {
    def df = new SimpleDateFormat("yyyyMMddHHmmss")
    df.setTimeZone(TimeZone.getTimeZone("Europe/Warsaw"))
    return df.format(new Date())
}

def gitSha() {
    return 'git rev-parse --short HEAD'.execute().text.trim()
}

task wrapper(type: Wrapper) {
    gradleVersion = '2.2.1'
}
```
