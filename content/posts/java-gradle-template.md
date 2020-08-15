---
title: Java Gradle Template
date: 2014-10-17 23:11:00
tags:
- java
- gradle
---

Some time ago, I had some troubles with configuring Java project with Gradle in IntelliJ IDEA CE. There is possibility to create new Gradle project in mentioned IDE, but for some reason it didn't worked out-of-the box in my case on Ubuntu. I wanted to have pure, clean Java project with Gradle build system ready to open in IntelliJ IDEA. I found well configured simple project at: [https://github.com/quinnliu/SampleGradleProject](https://github.com/quinnliu/SampleGradleProject). Basing on that project, I created my simple template. I modified this project a little bit, added [FEST assertions](https://github.com/alexruiz/fest-assert-2.x) and wrote a few Unit Tests. In addition, I configured main class in `build.gradle` file in order to execute it via `./gradlew run` command. My project template also has gradle wrapper, which is very convenient practice. 

You can find my project template at: [https://github.com/pwittchen/java-gradle-template](https://github.com/pwittchen/java-gradle-template) 
If you want to compile project, run the following command: `./gradlew clean build` 
If you want to start tests, run the following command: `./gradlew test` Actually `build` command will run tests as well. 
If you want to run application, use the following command: `./gradlew run`. 
You can also run application, tests or start compilation from the IntelliJ IDEA IDE. 

I hope, you will find that template useful and handy.