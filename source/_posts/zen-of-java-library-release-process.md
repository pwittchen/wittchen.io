---
title: Zen of the Java library release process
tags:
  - java
  - gradle
  - library
  - release
  - open-source
date: 2019-06-08 10:58:10
---


In my [previous article](/2019/05/24/publishing-jar-aar-to-maven-central/) I published information about publishing JAR/AAR library to the Maven Central Repository. A few steps of that process were automated, but a few of them were still manual. I mean closing and release process which had to be done by manual clicking on the Sonatype website. Fortunately, it's possible to automate it. In order to do that, I used [gradle-nexus-staging-plugin](https://github.com/Codearte/gradle-nexus-staging-plugin) developed by [Codearte](https://github.com/Codearte). Thanks to this plugin I could get rid of the remaining manual steps left in the release process. 

**Please note**, if you want to apply configuration described in this article to your project, you need to perform the steps described in the article about [Publishing JAR/AAR to the Maven Central](/2019/05/24/publishing-jar-aar-to-maven-central/).

In my project, in the top-level [build.gradle](https://github.com/pwittchen/ReactiveNetwork/blob/RxJava2.x/build.gradle) file I had to do the following setup:

```gradle
apply plugin: 'io.codearte.nexus-staging'

...

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
    ...
    classpath "io.codearte.gradle.nexus:gradle-nexus-staging-plugin:0.12.0"
  }
}

...

def getRepositoryUsername() {
  return hasProperty('NEXUS_USERNAME') ? NEXUS_USERNAME : ""
}

def getRepositoryPassword() {
  return hasProperty('NEXUS_PASSWORD') ? NEXUS_PASSWORD : ""
}

nexusStaging {
  packageGroup = GROUP //optional if packageGroup == project.getGroup()
  stagingProfileId = "YOUR_STAGING_PROFILE" //when not defined will be got from server using "packageGroup"
  username = getRepositoryUsername()
  password = getRepositoryPassword()
}
```

In order to get `YOUR_STAGING_PROFILE`, we need to call the following command available in the plugin:

```
./gradlew getStagingProfile
```

When we are done, we can simply call:

```
./gradlew uploadArchives closeAndReleaseRepository
```

These two gradle tasks will upload our artifact, close and release it, so we won't have to perform any manual steps in that process. After that, we just need to wait for the Maven sync as usual.

My complete `release.sh` script looks like that:

```bash
#!/usr/bin/env bash
./gradlew clean build test check uploadArchives closeAndReleaseRepository
```

Before upload and release, I'm also cleaning everything, building an artifact, run tests and static code analysis. It's not required, but it's good to do that.

If you are interested in complete project configuration, you can have a look at the https://github.com/pwittchen/ReactiveNetwork repository. It's an Android library, but the same configuration can be applied to any JVM project built with Gradle. I have performed library release with this plugin a few times and it seems to work well.
