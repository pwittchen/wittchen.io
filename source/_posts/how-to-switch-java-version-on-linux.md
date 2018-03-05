---
title: How to switch java version on Linux
date: 2014-11-02 12:33:00
tags:
	- java
	- linux
---

Sometimes we need to run specific program with a concrete version of JVM. We can also work with Java 7, but we want to try Java 8. In such cases, we can have installed both Java 7 and 8 on our system and easily switch between them. In order to show current java version, we can simply type: `java -version` in terminal. On my computer I received the following response:

```
Picked up JAVA\_TOOL\_OPTIONS: -javaagent:/usr/share/java/jayatanaag.jar
java version "1.8.0_25"
Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
```

We can see that I am using Java 8. If we want to switch to Java 7, we can use the following command: 

```
sudo update-alternatives --config java
```

I am using Polish lanugage version of Ubuntu, so I received response, which you can see below. If you are using another language version, you will see messages in your language.

```
Są 3 dostępne alternatywy dla java (dostarczające /usr/bin/java).

  Wybór       Ścieżka                                       Priorytet  Status
------------------------------------------------------------
  0            /usr/lib/jvm/java-8-oracle/jre/bin/java          1075      tryb auto
  1            /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java   1071      tryb ręczny
  2            /usr/lib/jvm/java-7-oracle/jre/bin/java          1074      tryb ręczny
* 3            /usr/lib/jvm/java-8-oracle/jre/bin/java          1075      tryb ręczny

Proszę wcisnąć Enter, aby pozostawić bieżący wybór[*]; albo wpisać wybrany numer:
```

Basically, we can just type number of a concrete version of JVM and press Enter. Currently, I have Oracle Java 7, Oracle Java 8 and Open JDK 7 installed in the system. When we type 2, we will switch to Java 7. 
After that, when we type: `java -version`, we will see the following message:

```
Picked up JAVA\_TOOL\_OPTIONS: -javaagent:/usr/share/java/jayatanaag.jar 
java version "1.7.0_72"
Java(TM) SE Runtime Environment (build 1.7.0_72-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.72-b04, mixed mode)
```

If we want to switch back to Java 8, we can do it in the same way.
