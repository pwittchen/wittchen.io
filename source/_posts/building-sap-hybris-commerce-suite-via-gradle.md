---
title: Building and running SAP Hybris Commerce Platform via Gradle
date: 2017-09-01 18:25:00
tags:
	- hybris
	- gradle
---

Introduction
------------

I really like [Gradle](https://gradle.org/) build system for JVM apps. It has flexibility like [Ant](http://ant.apache.org/) and great dependency management capabilities like [Maven](https://maven.apache.org/). It addition, it doesn't use XML notation, but Groovy programming language, so builds configurations are simple, concise, easier to read and easier to create. In my opinion, Gradle is truly modern build system for JVM apps. Nevertheless, there are projects, which are pretty old and use older systems like Ant. For example, all Hybris projects are based on Ant. Moreover, they have their custom setup and configurations, internal extensions system, etc. I was wondering if it's possible to migrate Hybris Platform build from Ant to Gradle. That's why I created a simple Proof of Concept.

Migrating from Ant to Gradle
----------------------------

If we want to use Gradle, we need to install it first.

```bash
sudo apt-get install gradle         # if we're on Ubuntu Linux
brew install gradle                 # if we're on macOS
```

For more details and instructions for other systems, check [official Gradle installation guide](https://gradle.org/install/). Then, we need to go to our Hybris platform directory and navigate to `hybris/bin/platform` After that, we need to initialize gradle inside this directory by running `gradle` command. Next, we need to create gradle wrapper by running `gradle wrapper` command. Now we should have the following elements in our directory:

*   `.gradle` (directory)
*   `graldew` (wrapper file for Unix)
*   `gradlew.bat` (wrapper file for Windows)

Afterwards, we can create `build.gradle` configuration file. It should have the following contents:

```gradle
ant.importBuild 'build.xml'
apply plugin: 'java'

repositories {
  jcenter()
}

task run() {
  doLast {
     exec {
          executable "./hybrisserver.sh"
      }
  }
}

task cleanGeneratedDirs(type: Delete) {
  delete "../../data"
  delete "../../log"
  delete "../../roles"
  delete "../../temp"
}

task cleanConfig(type: Delete) {
  delete "../../config"
}

dependencies {
  compile fileTree(dir: 'lib', include: \['*.jar'\])
}
```

Now, we can execute the following command:

```
./gradlew clean build
```

and platform will be built. In order to initialize the platform, we can call:

```
./gradlew initialize
```

If we want to start the Hybris server, we can simply call:

```
./gradlew run
```

To clear directories generated during build and initialization, we can run:

```
./gradlew cleanGeneratedDirs
```

I tried to make `clean` task dependent on this one, but I got a few errors and didn't spend too much time on investigating them. As you probably noticed, this solution is just a wrapper around Ant build defined in `build.xml` file and it's not pure Gradle build configuration. Nevertheless, these tips may be useful for the people who need to have custom build configurations and dependencies. There's no doubt that creating and maintaining configurations via Gradle is much easier and more convenient than doing the same job via Ant.

Summary
-------

As we can see, it's possible to migrate Hybris build from Ant to Gradle, but please remember that Hybris has a custom setup and it may not be the best decision in each case. We should always consider pros and cons of such solution and adjust it to our needs. In legacy systems, we often have to stick to existing setups because making "revolution" may be a huge overhead and doesn't have to pay off. Moreover, all Hybris extensions also have build configurations based on Ant. On the other hand, I can highly recommend Gradle for greenfield JVM projects.

References
----------

There's another nice, short article describing migrating Java projects from Ant to Gradle: [Easily Convert from Ant to Gradle (objectpartners.com)](https://objectpartners.com/2017/05/04/easily-convert-from-ant-to-gradle/).