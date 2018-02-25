---
title: Different build config for debug and release version of the Android app
date: 2014-10-08 17:52:00
tags:
	- android
	- gradle
---

Sometimes we may want to set different address of the back-end web service for debuggable and release version of our Android app. E.g. predefined static host and port for release version of the application and our local IP address and predefined port for debuggable version of the application. In second case, we can deploy back-end webservice on our local machine for testing purposes. We can customize all of that in build.gradle file. We can use `variant.buildType.isDebuggable()` instruction to check build type of the app. I described way of [Updating Android XML resources before compilation via Gradle](http://blog.wittchen.biz.pl/updating-android-xml-resources-dynamically-before-compilation-via-gradle/) in [one of my previous posts](http://blog.wittchen.biz.pl/updating-android-xml-resources-dynamically-before-compilation-via-gradle/), so you can check it if you don't understand `replaceBackendAddressInResources(variant, host, port)` method. After proper configuration, setting of the back-end url is straightforward. Please check the code between `// configuration of the back-end address - begin` and `// configuration of the back-end address - end` comments. 

```gradle
import java.text.SimpleDateFormat
apply plugin: 'com.android.application'

android {
    compileSdkVersion 20
    buildToolsVersion '20.0.0'

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    lintOptions {
        abortOnError false
        disable 'MissingTranslation'
    }

    defaultConfig {
        applicationId "com.android.app"
        minSdkVersion 15
        targetSdkVersion 19
        versionCode 1
        versionName gitSha() + '-' + buildTime()
        testInstrumentationRunner "com.google.android.apps.common.testing.testrunner.GoogleInstrumentationTestRunner"
    }

    buildTypes {
        release {
            runProguard false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.releaseConfig
        }
    }

    // configuration of the back-end address - begin

    applicationVariants.all { variant ->
        variant.mergeResources.doLast {
            if(variant.buildType.isDebuggable()) {
                replaceBackendAddressInResources(variant, obtainLocalIpAddress(), "8443")
            } else {
                replaceBackendAddressInResources(variant, "PUT YOUR PRODUCTION SERVER ADRESS HERE", "PRODUCTION PORT")
            }
        }
    }

    // configuration of the back-end address - end

    packagingOptions {
        exclude 'META-INF/DEPENDENCIES.txt'
        exclude 'META-INF/LICENSE.txt'
        exclude 'LICENSE.txt'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/notice.txt'
        exclude 'META-INF/license.txt'
        exclude 'META-INF/dependencies.txt'
        exclude 'META-INF/LGPL2.1'
        exclude 'ASL-2.0.txt'
        exclude 'LGPL-3.0.txt'
        exclude 'META-INF/ASL-2.0.txt'
        exclude 'META-INF/LGPL-3.0.txt'
        exclude 'META-INF/services/javax.annotation.processing.Processor'
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
}

def replaceBackendAddressInResources(variant, host, port) {
    // replace the #const_backend_url# with your specific ip address
    def protocol = "https://"
    def backendAddress = protocol + host + ":" + port + "/"
    File valuesFile = file("${buildDir}/intermediates/res/${variant.dirName}/values/values.xml")
    if (valuesFile.exists()) {
        String content = valuesFile.getText('UTF-8')
        content = content.replaceAll("#const_backend_url#", backendAddress)
        valuesFile.write(content, 'UTF-8')
        println("Replacing #const_backend_url# with " + backendAddress + " in file: " + valuesFile.name)
    } else {
        println("File: " + valuesFile.path + " does not exist")
    }
}

def obtainLocalIpAddress() {
    InetAddress inetAddress = InetAddress.getLocalHost();
    byte[] address = inetAddress.getAddress();
    String ipAddress = "";

    for (int i = 0; i < address.length; i++) {
        if (i > 0) {
            ipAddress += ".";
        }
        ipAddress += address[i] & 0xFF;
    }
    ipAddress
}

def buildTime() {
    def df = new SimpleDateFormat("yyyyMMddHHmmss")
    df.setTimeZone(TimeZone.getTimeZone("Europe/Warsaw"))
    return df.format(new Date())
}

def gitSha() {
    return 'git rev-parse --short HEAD'.execute().text.trim()
}
```

Now, you can create release and debug version of the app with different addresses of the web service what is very useful during the process of development and deployment of the project. We can use this trick also for setting different parameters depending on our needs.
