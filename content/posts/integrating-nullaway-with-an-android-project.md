---
title: Integrating ErrorProne and NullAway with an Android project
date: 2017-09-15 18:39:00
tags:
- java
- android
---

Recently, with the [remote help of guys from Uber in California](https://github.com/pwittchen/ReactiveNetwork/pull/226), I integrated [NullAway](https://github.com/uber/NullAway/) and [ErrorProne](https://github.com/google/error-prone) with the [one of my open-source Android projects](https://github.com/pwittchen/ReactiveNetwork).

What is NullAway?
-----------------

Basically, it's _a tool to help eliminate NullPointerExceptions (NPEs) in your Java code_. It detects situations where NPE could occur at the compile time. Let's have a look at the following code:

```java
static void log(Object x) {
    System.out.println(x.toString());
}
static void foo() {
    log(null);
}
```

NullAway will find out that we're passing `null` and we'll get appropriate error message:

```
warning: [NullAway] passing @Nullable parameter 'null' where @NonNull is required
    log(null);
        ^
```

It's good to have checks like that because they eliminate possible bugs in advance and follows Clean Code principles.

A few words about ErrorProne
----------------------------

NullAway is built as a plugin to [ErrorProne](http://errorprone.info/) and can run on every single build of our code. Moreover, ErrorProne can perform other checks on our code, which can find out commonly people mistakes. E.g. it can detect a situation, where programmer forgot to add `@Test` annotation in the unit test method in a test suite and other things. It has built-in [bug patterns](http://errorprone.info/bugpatterns), which are used during code analysis.

Integration with the Android project
------------------------------------

I've integrated ErrorProne and NullAway with [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) Android library. First, in the main `build.gradle` file, I've added the following lines:

```gradle
ext.deps =  [
            ...
            nullaway          : 'com.uber.nullaway:nullaway:0.1.2',
            errorprone        : 'com.google.errorprone:error_prone_core:2.1.1',
            ...
            ]

buildscript {
  repositories {
    jcenter()
    maven {
      url 'https://plugins.gradle.org/m2/'
    }
  }
  dependencies {
    ...
    classpath 'net.ltgt.gradle:gradle-errorprone-plugin:0.0.11'
    classpath 'net.ltgt.gradle:gradle-apt-plugin:0.11'
    // NOTE: Do not place your application dependencies here; they belong
    // in the individual module build.gradle files
  }
}
```

Next, in the `library/build.gradle` file, I've added appropriate plugins in the top:

```gradle
apply plugin: 'net.ltgt.errorprone'
apply plugin: 'net.ltgt.apt'
```

Afterwards, I could add dependencies:

```gradle
dependencies {
  ...

  annotationProcessor deps.nullaway
  errorprone deps.errorprone
}
```

The last thing to do, is the task responsible for running analysis during project compilation:

```gradle
tasks.withType(JavaCompile) {
  if (!name.toLowerCase().contains("test")) {
    options.compilerArgs += ["-Xep:NullAway:ERROR", "-XepOpt:NullAway:AnnotatedPackages=com.github.pwittchen.reactivenetwork"]
  }
}
```

That's it! Now, I could run analysis by typing:

```
./gradlew check
```

and fix the issues. I think, a quite similar approach and configuration could be applied to a regular, pure Java project built with Gradle. If you're interested in the complete configurations, check it out in my project at: [https://github.com/pwittchen/ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). You can also view [Pull Request #226](https://github.com/pwittchen/ReactiveNetwork/pull/226) made by [@msridhar](https://github.com/msridhar) (kudos for him!).
