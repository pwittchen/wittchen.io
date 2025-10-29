---
title: Kirai - flavored Android string formatting library
date: 2015-01-13 19:12:00
tags:
- android
- java
- open-source
---

Overview
--------

Recently I've developed and realased to Maven Central Repository **[Kirai](https://github.com/pwittchen/kirai/)**, which is **flavored Android string formatting library**. Kirai means _phrase_ in Swahili language. Project is inspired by [phrase](https://github.com/square/phrase), [TaggerString](https://github.com/polok/TaggerString) and [BabushkaText](https://github.com/quiqueqs/BabushkaText). Kirai has fluent API similar to phrase with additional formatting similar to TaggerString and allows to add formatted pieces of text like BabushkaText. Development including writing Unit Tests took me about 2 days. Deployment and release to Maven Central Repository took me about 2 days as well. It was my first deployment, so it wasn't so easy, but people from Sonatype are helpful, problems were solved very quickly and release went quite smooth.

Usage
-----

Usage of the library is quite simple: 

```java
// Basic Usage

CharSequence formatted = Kirai
   .from("Hi {first_name}, your are {age} years old.")
   .put("first_name", firstName)
   .put("age", age)
   .format();

// Flavored Usage

CharSequence formatted = Kirai
   .from("Hi {first_name}, your are {age} years old.")
   .put(Piece.put("first_name", firstName).bold().italic().big())
   .put(Piece.put("age", age).underline().color("#FF0000"))
   .format();

textView.setText(formatted);

```

Download
--------

You can depend on this library through Maven: 

```xml
<dependency>
    <groupId>com.github.pwittchen.kirai</groupId>
    <artifactId>library</artifactId>
    <version>1.0.0</version>
</dependency>
```

or through Gradle: 

```gradle
dependencies {
  compile 'com.github.pwittchen.kirai:library:1.0.0'
}
```

Open-source
-----------

Library is open-source and available on GitHub at: [https://github.com/pwittchen/kirai/](https://github.com/pwittchen/kirai/) If you want to know more about library, check GitHub website of the project. Feel free to use it or fork it!