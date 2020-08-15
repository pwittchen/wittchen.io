---
title: Separate execution of unit and integration tests in Gradle
tags:
  - java
  - gradle
  - testing
date: 2018-09-22 16:51:47
---


During development process, we often write unit and integration tests. While unit tests verify corectness of the small pieces of code, integration tests verify software as a whole project and sometimes can treat it as a black box where concrete results are expected. During development of the REST API, we can write integration tests for such API with [REST Assured](https://github.com/rest-assured/rest-assured). Integration tests are usually slower, because they need to start the server and sometimes do other stuff. That's why it's good to separate their execution from regular unit tests. On the CI server we can even have separate job for them.

We can define the following project structure:

```
+ src
|
+- main
|  |
|  +- java
|    |
|    +- com ...
|
+- test
  |
  +- java
    |
    +- com ... (unit tests)
    |
    +- integration (integration tests)
    
```

In the `java/com/` directory we can put unit tests and in the `integration/` directory we can put integration tests.

Now, we can prepare the following configuration in the `build.gradle`:

```gradle
test {
  if (System.properties['test.profile'] != 'integration') {
    exclude '**/*integration*'
  } else {
    exclude '**/*com/*'
  }
}
```

As you can see, when `test.profile` is different than `integration/`, we're excluding `integration/` directory from tests. Otherwise, we're excluding `com/` directory.

Now, when we want to execute unit tests only, we can type the following command:

```
./gradlew test
```

but when we want to run unit test, we can type:

```
./gradlew test -Dtest.profile=integration
```

When we want to execute all tests, we can redefine configuration above, write another gradle task or perform one execution after another:

```
./gradlew test && ./gradlew test -Dtest.profile=integration
```

That's it!
