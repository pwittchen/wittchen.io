---
title: Publishing a JAR/AAR to the Maven Central
tags:
    - java
    - maven
    - gradle
    - sonatype
    - open-source
---

## Introduction

As a Java/JVM/Android developers we rely on the work of other people through frameworks and libraries. Many of them are open-source. Most of the developers are consumers of such projects. What if we would like to create our own library and distribute it to other developers? We can always create it and share a `*.jar` or `*.aar` file with others. Drawback of such solution is the fact that source of distribution may not be trusted. We also have problems with versioning. Consumers of the library have to constantly download and update the files. It's much better to publish our library to Maven Central Repository and allow others to easily and seamlessly add it as an external dependency to `pom.xml` file (in case of Maven) or `build.gradle` file (in case of Gradle). In such case dependency is managed by the appropriate build system and distributed via trusted source. Let's see how to do this.

## Generating certificates

...

## Preparing Gradle configuration

...

## Creating Jira ticket for Sonatype

...

## Uploading an artifact

...

## Releasing an artifact

...

## Wait for the Maven sync

...

## Summary

...

## Links
- https://stackoverflow.com/questions/28846802/how-to-manually-publish-jar-to-maven-central
- https://chris.banes.dev/2013/08/27/pushing-aars-to-maven-central/
- https://dzone.com/articles/deploy-maven-central
- https://central.sonatype.org/pages/ossrh-guide.html#deployment
- https://central.sonatype.org/pages/apache-maven.html
- https://central.sonatype.org/pages/working-with-pgp-signatures.html
