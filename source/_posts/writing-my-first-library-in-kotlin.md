---
title: Writing my first library in Kotlin
tags:
  - java
  - kotlin
  - android
  - gradle
date: 2018-08-19 10:24:19
---


## Introduction

Recently, I decided to create a tiny Android library called [RxBattery](https://github.com/pwittchen/RxBattery), which is monitoring battery state of the device with RxJava and RxKotlin. I created a few Java and Android libraries already and this time I decided to use [Kotlin](https://kotlinlang.org/) programming language instead of Java to learn something new and write something more complicated than "Hello World" app. Here are my observations.

## Build System

I used [Gradle](https://gradle.org/) to build the project. It's popular for JVM and Android apps nowadays and works fine with Kotlin. I just needed to add Kotlin Gradle Plugin and Kotlin STD Lib to the `/library/build.gradle` file to the `classpath` dependencies in `buildscript` section. I also needed to define `sourceSets` to allow IntelliJ and Android Studio recognize directories with sources.

```groovy
android {
  sourceSets {
    androidTest.java.srcDirs += "src/androidTest/kotlin"
    main.java.srcDirs += "src/main/kotlin"
    test.java.srcDirs += "src/test/kotlin"
  }
}
```

To keep the project clean, I defined all dependencies and version numbers in top-level `build.gradle` file, so I could reuse them in all modules.

```groovy
ext {
  minSdkVersion = 14
  compileSdkVersion = 28
  buildToolsVersion = '28'
  gradleVersion = '4.4.1'
  kotlinVersion = '1.2.60'
  detektVersion = '1.0.0.RC6-1'
}

ext.deps = [ rxjava2              : 'io.reactivex.rxjava2:rxjava:2.2.0',
             rxandroid2           : 'io.reactivex.rxjava2:rxandroid:2.0.2',
             rxkotlin2            : 'io.reactivex.rxjava2:rxkotlin:2.3.0',
             supportannotations   : 'com.android.support:support-annotations:28.0.0-rc01',
             appcompatv7          : 'com.android.support:appcompat-v7:28.0.0-rc01',
             constraintlayout     : 'com.android.support.constraint:constraint-layout:1.1.2',
             junit                : 'junit:junit:4.12',
             truth                : 'com.google.truth:truth:0.42',
             robolectric          : 'org.robolectric:robolectric:4.0-alpha-3',
             mockitocore          : 'org.mockito:mockito-core:2.21.0',
             mockitokotlin        : 'com.nhaarman.mockitokotlin2:mockito-kotlin:2.0.0-RC1',
             dokka                : 'org.jetbrains.dokka:dokka-gradle-plugin:0.9.17',
             detekt               : "gradle.plugin.io.gitlab.arturbosch.detekt:detekt-gradle-plugin:$detektVersion",
             ktlintgradle         : "gradle.plugin.org.jlleitschuh.gradle:ktlint-gradle:4.1.0",
             kotlinstdlib         : "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlinVersion",
             kotlingradleplugin   : "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion" ]
```

## Static Code Analysis

For static code analysis, I used CheckStyle, FindBugs, PMD and Android Lint as usual. Moreover, I used [ktlint](https://github.com/shyiko/ktlint) via [ktlint-gradle plugin](https://github.com/JLLeitschuh/ktlint-gradle) and [detekt](https://github.com/arturbosch/detekt). I've added these dependencies to `classpath` in `buildscript` section in `library/build.gradle` file as previosuly

```groovy
buildscript {
  repositories {
    mavenCentral()
    jcenter()
    google()
    maven {
      url 'https://plugins.gradle.org/m2/'
    }
  }

  dependencies {
    classpath deps.kotlingradleplugin
    classpath deps.detekt
    classpath deps.ktlintgradle
    classpath deps.dokka
  }
}
```

I also applied minimal configuration for these plugins.

```groovy
detekt {
  version = rootProject.ext.detektVersion
  profile("main") {
    input = "$projectDir"
    config = "$projectDir/detekt.yml"
    filters = ".*test.*,.*/resources/.*,.*/tmp/.*"
  }
}

ktlint {
  verbose = true
  reporters = ["CHECKSTYLE", "PLAIN"]
}
```

I also tried to generate **code coverage report**, to be able to verify what amount of code is covered by unit tests, but unfortunately Jacoco wasn't able to analyze Kotlin code. I saw on the web that people struggled with the same problem and a few of them could have solved that issue. Maybe I missed something and I could update it in the future.

## Kotlin vs. Java

I've decided to use Kotlin instead of Java to learn a bit more about this language and try something new. Google promotes this language during Google I/O events and recommends to use it for Android development. Moreover, it's regular JVM language, so we can use it anywhere we want - on Android (mobile), on servers and even on desktop apps. I haven't discovered all the features of this language during writing this tiny project, but I have a few observations. Writing code is a bit strange because I got used to programming in Java. In Kotlin, we define the function or variable name first, then we put colon and we define the type next. It's opposite to Java, where types are defined first. 

```kotlin
fun createBroadcastReceiver(emitter: FlowableEmitter<BatteryState>): BroadcastReceiver {
  ...
  val status: Int = intent.getIntExtra(BatteryManager.EXTRA_STATUS, UNKNOWN)
  ...
}
```

Moreover, there's type inference in Kotlin and sometimes compiler is able to guess our type, so we don't have to provide it. See the following example:

```kotlin
val emitter = mock(FlowableEmitter::class.java)
```

In addition, we don't have to put semicolon in the end of the statement as you can see on the code snippets above, what is really convenient. The thing, I really like about Kotlin is **null safety**

```kotlin
if (intent != null) {
  val status: Int = intent.getIntExtra(BatteryManager.EXTRA_STATUS, UNKNOWN)
}
```

If we don't do that, code won't compile. We can avoid such null-checks, by using `!!.` operator like here:

```kotlin
val status: Int = intent!!.getIntExtra(BatteryManager.EXTRA_STATUS, UNKNOWN)
```

but by looking at the code, we can see that there are two exclamation marks, so clearly something must be wrong here, so we should think about improvement and when NPE occurs, it'll be easier to find.

Kotlin is also **more concise** than Java. It's hard to say if it's an advantage or drawback. In Java we have more code, but we clearly know what's going on when the code is clean. In Kotlin a lot of stuff is **implicit**.

E.g. inheritance looks as follows:

```kotlin
class MainActivity : AppCompatActivity()
```

and sometimes we don't have variable provided in the lambda, when there's only one value and we can invoke this value by calling `it` object

```kotlin
batteryDisposable = RxBattery
  .observe(this)
  .subscribeOn(Schedulers.io())
  .observeOn(AndroidSchedulers.mainThread())
  .subscribe { textView.text = it.toString() }
```

The thing I like about implicit Kotlin code is data classes. We can create something like that:

```kotlin
data class BatteryState(
  val status: Int,
  val plugged: Int,
  val health: Int,
  val level: Int,
  val temperature: Int,
  val voltage: Int
)
```

and it will generate constructor with all these values, getters and `toString()` method. In Java, we would need to write it by hand, use code generators in the IDE or code generation libraries like Lombok.

It's worth to say that there's good **inter-operability** between Java and Kotlin. We can use Kotlin modules and libraries in Java projects and vice-versa because everything compiles to the same byte-code. We can even create pure Java code in the Kotlin module. For example, I wanted to have static method called from the Kotlin library. In order to achieve that, I needed to wrap whole class in a Companion Object.

```kotlin
class RxBattery {
  companion object {
    ...
  }
}
```

Next, in the Kotlin module, I could call it like this:

```kotlin
RxBattery.observe(this)
```

but in Java module it wasn't possible and I needed to write something like this:

```java
RxBattery.Companion.observe(context);
```

I didn't want library users to call this `Companion` value explicitely in Java projects, so I created additional Java class.

```java
public class RxBatteryFactory {

  private RxBatteryFactory() {
  }

  public static Flowable<BatteryState> observe(Context context) {
    return RxBattery.Companion.observe(context);
  }
}
```

and put it next to the Kotlin classes. Now In Java module, people could call method like that:

```java
RxBatteryFactory.observe(this)
```

It's good to know that it's possible because when we got stuck with implicit Kotlin syntaxt, we can always use Java in one particular scenario.

It's hard to say if in more complex project Kotlin would be a better choice. Right now, I'm more familar and comfortable with Java, but on the other hand, Kotlin has a few interesting features, which makes development better. Maybe I'll give this language more chances in the future to learn it better.

## Unit Tests

Unit tests in Kotlin are pretty similar to Java.

```kotlin
@Test fun shouldCreateBroadcastReceiver() {
  // given
  val emitter = mock(FlowableEmitter::class.java)

  // when
  val broadcastReceiver: BroadcastReceiver = RxBattery.createBroadcastReceiver(
    emitter as FlowableEmitter<BatteryState>
  )

  // then
  assertThat(broadcastReceiver).isNotNull()
}
```

We can use JUnit and Java assertion libraries like Google Truth and mocking libraries like Mockito. There's also mockit-kotlin library, but in my case, I used mockito-core. There are also other mocking libraries like MockK and libraries for BDD like Spek.

## JavaDoc

Generating JavaDoc (or KotlinDoc?) in Kotlin projects is not straightforward. In order to generate documentation, I used [dokka](https://github.com/Kotlin/dokka) gradle plugin. It's pretty easy to use, we just need to add appropriate dependency, apply the plugin and create configuration in `build.gradle` file.

```groovy
dokka {
  outputFormat = 'html'
  outputDirectory = "$buildDir/javadoc"
}
```

Next, we just call: `./gradlew dokka` and our JavaDoc is generated in defined `outputDirectory`.

## Library Deployment

Library deployment of the Kotlin project is exactly the same as Java project. I simply used [`maven_push.gradle`](https://github.com/pwittchen/RxBattery/blob/master/maven_push.gradle) script created by Chris Banes some time ago, applied it in the library module and configured everything in `gradle.properties` and `library/gradle.properties`. Of course, I also needed to have my credentials configured in `~/.gradle/gradle.properties` file. Next, I could just call `./gradlew uploadArchives`, close and release library on the OSS SonaType website.

## Summary

To wrap up, Kotlin is an interesting language. It's hard to say, if it's really better than Java although it has a few interesting features. Nevertheless, it's good to familiarize with it because it's being promoted by Google and JetBrains. JetBrains company actually created and develops this language, so due to this fact, I'm able to put more trust in that project. If you would like to see complete code and configuration of the project mentioned in this article, check out my [RxBattery](https://github.com/pwittchen/RxBattery) repository on GitHub. Last, but not least, learning new things broadens our mind and horizon.
