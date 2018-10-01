---
title: Creating a fat AAR
tags:
  - java
  - gradle
  - android
date: 2018-10-02 00:01:31
---


I recently wrote a new library called [NeuroSky Android SDK](https://github.com/pwittchen/neurosky-android-sdk). It's used for writing Android apps using signals of the brain waves received from the NeuroSky MindWave Mobile headsets. Probably I'll write a separate article about it because it's quite interesting topic. This library uses ThinkGear library, which is distributed by the NeuroSky as a `*.jar` file, so I couldn't use it as a Gradle or Maven dependency in my project and I had to put this `*.jar` file into the `lib` directory and link it in the `build.gradle` file. Moreover, I wanted to create a library, which can be added to the project as a single Gradle dependency without messing around with additional `*.jar` files or custom configuration. Due to this fact, I decided to create a fat `*.aar` file and deploy it to the Maven Central repository. For those who are not familar with Android, `*.aar` is an Android version or `*.jar` file, which can be used as library in the project. I didn't want to reinvent the wheel, so I searched for the different solutions. Unfortunatey, a few of them didn't work, but luckilly I've found what I wanted. It's [fat AAR Gradle Plugin](https://github.com/Mobbeel/fataar-gradle-plugin) developed by [Mobbeel](https://github.com/Mobbeel) company.

Here's how I configured everything:

In my top-level `build.gradle` file I defined dependency to my custom `*.jar` file and other dependencies.

```gradle
ext.deps = [ // other dependencies goes here...
             thinkgear : files('library/libs/ThinkGear.jar')
           ]
```

Next, I added dependency to the plugin within a `buildscript` section.

```gradle
buildscript {
  repositories {
    google()
    jcenter()
    mavenCentral()
    maven {
      url 'https://plugins.gradle.org/m2/'
    }
  }
  dependencies {
   // other plugin dependencies goes here...
   classpath 'gradle.plugin.com.mobbeel.plugin:mobbeel-fataar:1.2.0'
  }
}
```

After that, in the `library/build.gradle` file, I could add dependency to the `*.jar` file.

```
dependencies {
  api deps.thinkgear
  // other dependencies goes here...
}
```

Then plugin could be applied.

```gradle
apply plugin: 'com.mobbeel.plugin'
```

And I could configure it.

```gradle
fatAARConfig {
  includeAllInnerDependencies false
}
```

When we set `includeAllInnerDependencies` parameter to `true`, then all transitive dependencies will be included in the fat `*.aar`. Default value is `false` and it's OK for now. I could even skip this step, but sometimes I prefer to define things explicitly.

Now, we can build our library.

```
./gradlew build
```

and fat `*.aar` will be generated in the `library/builds/output/` directory as a `library-release.aar` file. There should be also `library-debug.aar`. We can unzip this file and notice that it has the following structure:

```
.
├── AndroidManifest.xml
├── classes.jar
└── libs
    ├── rxandroid.jar
    ├── rxjava-2.2.2.jar
    └── ThinkGear.jar
```

so we can clearly see that all project dependencies are included in the `*.aar` file. Library deployed to the Maven Central Repository looks the same and now, users can add library as a single dependency to the project in the `build.gradle` file.

```gradle
dependencies {
  implementation 'com.github.pwittchen:neurosky-android-sdk:0.0.2'
}
```

`*.jar` library shipped inside `*.aar` file will be included in the project and everything will just work.
