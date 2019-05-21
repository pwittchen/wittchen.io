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

## Generating PGP Key

In order to generate [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) key, we need to open the terminal and type the following command:

```
gpg2 --gen-key
```

Then, we should see the output:

```
...
gpg: key YOUR_KEY_ID marked as ultimately trusted
```

## Distributing public key

Next, we need to distribute public key. We can do that as follows:

```
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys YOUR_KEY_ID
```

We can distribute our key to multiple servers to speed up the synchronization process (pgp.mit.edu, keyserver.ubuntu.com, etc.)

## Preparing Gradle configuration

In my case, I used Gradle as a build system, which works well for Java, Kotlin and Android projects. We can use Maven for this purpose as well. As a reference, I used [a Gradle script prepared by Chris Banes](https://github.com/chrisbanes/gradle-mvn-push). You can have a look at it in [one of my projects](https://github.com/pwittchen/ReactiveNetwork/blob/RxJava2.x/maven_push.gradle).

In my libraries, I usually have the following structure:

```
/
├── library
    ├── gradle.properties
│   └── build.gradle
│
├── build.gradle
├── maven_push.gradle
└── gradle.properties
```

In `maven_push.gradle` I keep the mentioned release script. In the `library/gradle.properties`, I keep details about artifact released from a given directory:

```
POM_NAME=reactivenetwork
POM_ARTIFACT_ID=reactivenetwork-rx2
POM_PACKAGING=aar
```

It can be `jar` if you're releasing pure Java library. Here's an example for Android library.

In the `/gradle.properties` file, I keep release configuration:

```
VERSION_NAME=3.0.3
VERSION_CODE=34
GROUP=com.github.pwittchen

POM_DESCRIPTION=Android library listening network connection state and Internet connectivity with RxJava Observables
POM_URL=https://github.com/pwittchen/ReactiveNetwork
POM_SCM_URL=https://github.com/pwittchen/ReactiveNetwork
POM_SCM_CONNECTION=scm:git@github.com:pwittchen/ReactiveNetwork.git
POM_SCM_DEV_CONNECTION=scm:git@github.com:pwittchen/ReactiveNetwork.git
POM_LICENCE_NAME=The Apache Software License, Version 2.0
POM_LICENCE_URL=http://www.apache.org/licenses/LICENSE-2.0.txt
POM_LICENCE_DIST=repo
POM_DEVELOPER_ID=pwittchen
POM_DEVELOPER_NAME=Piotr Wittchen

org.gradle.daemon=true
org.gradle.jvmargs=-XX:MaxPermSize=1024m -XX:+CMSClassUnloadingEnabled -XX:+HeapDumpOnOutOfMemoryError -Xmx2048m
```

In the `library/build.gradle` file I need to include release Gradle script:

```
apply from: '../maven_push.gradle'
...
```

In the `$HOME/.gradle/gradle.properties` file, I keep system-wide release configuration for SonaType:

```
signing.keyId=YOUR_KEY_ID
signing.password=YOUR_SIGNING_PASSWORD
signing.secretKeyRingFile=/home/piotr/.gnupg/secring.gpg
 
NEXUS_USERNAME=YOUR_NEXUS_USERNAME
NEXUS_PASSWORD=YOUR_NEXUS_PASSWORD
```

Of course, you need to provide your own path to `secretKeyRingFile`, which was created during generating PGP key.

## Creating Jira ticket for Sonatype

We should create a [SonaType Jira account](https://issues.sonatype.org/secure/Signup!default.jspa) and [a new project ticket](https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134). You can have a look at [my first issue](https://issues.sonatype.org/browse/OSSRH-13199). It took a bit longer in my case, because I needed to adjust package name. 

To avoid my mistakes, have a look at the following guides:
- https://central.sonatype.org/pages/ossrh-guide.html
- https://central.sonatype.org/pages/choosing-your-coordinates.html

Please note, this step is required for the first time only as well as generating keys. After that, we we'll be able to release as many artifacts under the given package name as we want. These steps need to be repeated in the case of registering the new package name.

## Uploading an artifact

Once, we have everything set up, we can go to our project via terminal, and type:

```
./gradlew uploadArchives
```

and wait while artifacts are being uploaded.

## Releasing an artifact

Next, we need to go to the http://oss.sonatype.org website, log in and on the left-hand side, click "Staging Repositories". Then, we need to sort artifacts by date (Updated column), to view the recently updated items. We should find our artifact (it should be on the top) and click it. We can verify its contents to ensure that everything is ok (package name, version, etc.) and then, we should press "Release" on our artifact. Once release is done, we should press "Close" on the artifact.

## Comment Jira ticket

When we are done with the previous steps, we should go back to our Jira ticket and provide the comment:

```
I have promoted my first release. Thanks.
```

## Wait for the Maven sync

After all of these steps, we need to wait for the acceptance from the people from SonaType and Maven Sync. Maven Sync can take no longer than 48 hours. It's usually faster, but it won't happen immediately after releasing and closing an artifact.

## Summary

...

## Links
- https://stackoverflow.com/questions/28846802/how-to-manually-publish-jar-to-maven-central
- https://chris.banes.dev/2013/08/27/pushing-aars-to-maven-central/
- https://dzone.com/articles/deploy-maven-central
- https://central.sonatype.org/pages/ossrh-guide.html#deployment
- https://central.sonatype.org/pages/apache-maven.html
- https://central.sonatype.org/pages/working-with-pgp-signatures.html
