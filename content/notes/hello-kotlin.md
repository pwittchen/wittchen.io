---
title: Hello Kotlin!
date: 2015-02-07 18:59:00
tags:
- android
- kotlin
---

I've recently played with [Kotlin](http://kotlinlang.org/) in order to create simple "Hello World" Android app using this new, fancy language from JetBrains. Kotlin is another programming language based on JVM, which can work with Java. It's aim is to reduce code boilerplate and create projects faster. In my simple Android project, I've also used [KotterKnife](https://github.com/JakeWharton/kotterknife) for injecting views. I've also added one simple `ActivityUnitTestCase`. Unfortunately, I couldn't convert it into Kotlin, because I wasn't allowed to call constructor of inherited class using `super()` method. You can read [related StackOverflow thread](http://stackoverflow.com/questions/27699184/in-kotlin-how-do-i-extend-a-class-that-has-multiple-constructors) in order to view more details. In order to use Kotlin, I followed instructions from [article on JetBrains blog](http://blog.jetbrains.com/kotlin/2013/08/working-with-kotlin-in-android-studio/). I've also needed [Kotlin plugin](https://plugins.jetbrains.com/plugin/6954?pr=idea) for Android Studio. 

Check out my GitHub repository: [https://github.com/pwittchen/HelloAndroidKotlin](https://github.com/pwittchen/HelloAndroidKotlin) 
View more samples in JetBrains repository: [https://github.com/JetBrains/kotlin-examples](https://github.com/JetBrains/kotlin-examples) 

It's also worth mentioning that there is a project created in Kotlin by JetBrains called [Spek](http://jetbrains.github.io/spek/) which is a specification framework for the JVM and you can use it for writing unit tests in the JVM projects in order to get human readable output. 

Furthermore, you can read document about Using Project Kotlin for Android by Jake Wharton: [https://docs.google.com/document/d/1ReS3ep-hjxWA8kZi0YqDbEhCqTt29hG8P44aA9W0DM8/](https://docs.google.com/document/d/1ReS3ep-hjxWA8kZi0YqDbEhCqTt29hG8P44aA9W0DM8/). 

In order to view basic code constructions in Kotlin, you can browse the following repository: [https://github.com/FutureProcessing/kotlin_showandtell](https://github.com/FutureProcessing/kotlin_showandtell). 

Kotlin is quite interesting language, which may be some kind of _Swift for Android_. Basic setup of Android project in Kotlin is definitely easier than project setup in Groovy. It looks promising and I'm looking forward to hearing about new updates concerning this language.
