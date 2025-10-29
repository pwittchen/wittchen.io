---
title: Updating Android XML resources before compilation via Gradle
date: 2014-09-10 21:22:00
tags:
- android
- gradle
- git
---

Problem
-------

In a team project, we encountered one of the common problems connected with mobile applications. Android application sends requests to backend web service and we don't have backend web service deployed right now on a separate server, so every mobile developer is compiling and running backend web service on the local machine for testing purposes. In the beginning, url of backend url looked as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="backend_url">192.168.1.1</string>
</resources>
```

Of course address varies on different machines.

When every developer was pushing changes, configuration of the backed url changed as well. It became annoying, so we decided to do something about that. 

Solution 1
----------

### Attempt #1

First, we came with an idea of ignoring local changes of the XML file, which contains backend url address.
It can be done via Git in the following way:

```
git update-index --assume-unchanged [<file>...]
```

We can undo this operation with such command:

```
git update-index --assume-unchanged [<file>...]
```

We can also add ignored alias to our .gitconfig file:

```
[alias]
ignored = !git ls-files -v | grep "^[[:lower:]]"
```

Then we can type: git ignored to display ignored files.

For more information check [StackOverflow discussion](http://stackoverflow.com/questions/1753070/git-ignore-files-only-locally).

This solution is kind of work-around, so we decided to do it better.

### Attempt #2

We could create alias for backend url and replace it before compilation dynamically via Gradle.

Our new configuration file `res/values/configuration.xml` looks like that:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="backend_url">#const_backend_url#</string>
</resources>
```

Then, our `build.gradle` file needed to be updated. The most important part starts in 29th line, where `#const_backend_url#` value is replaced with an IP address of the local machine, where mobile application is compiled. As I mentioned before, backend web service application is compiled on the same machine, so backend web service address will be proper in that case for testing purposes.

```gradle
apply plugin: 'com.android.application'

android {
    compileSdkVersion 20
    buildToolsVersion '20.0.0'

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    defaultConfig {
        applicationId "com.my.app"
        minSdkVersion 15
        targetSdkVersion 19
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "com.google.android.apps.common.testing.testrunner.GoogleInstrumentationTestRunner"
    }

    buildTypes {
        release {
            runProguard false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }

    // replace the #const_backend_url# with your current ip address to use your local backend web service
    applicationVariants.all { variant ->
        variant.mergeResources.doLast {
            def protocol = "https://"
            def localIp = obtainCurrentIpAddress()
            def port = "8443"
            def backendAddress = protocol + localIp + ":" + port + "/"
            File valuesFile = file("${buildDir}/intermediates/res/${variant.dirName}/values/values.xml")
            if(valuesFile.exists()) {
                String content = valuesFile.getText('UTF-8')
                content = content.replaceAll("#const_backend_url#", backendAddress)
                valuesFile.write(content, 'UTF-8')
                println("Replacing #const_backend_url# with " + backendAddress + " in file: " + valuesFile.name)
            } else {
                println("File: " + valuesFile.path + " does not exist")
            }
        }
    }

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
    compile 'com.jakewharton:butterknife:5.1.2'
    // put your another dependencies here
    androidTestCompile 'com.jakewharton.espresso:espresso:1.1-r3'
    androidTestCompile 'com.squareup:fest-android:1.0.8'
}

def obtainCurrentIpAddress() {
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
```

Similar trick was applied in project: https://github.com/nenick/android-gradle-template in file https://github.com/nenick/android-gradle-template/blob/master/App/build.gradle, so you can check it out.