---
title: Publishing a JAR/AAR to the Maven Central
tags:
  - java
  - maven
  - gradle
  - sonatype
  - open-source
date: 2019-05-24 19:18:27
---


## Introduction

As a Java/JVM/Android developers we rely on the work of other people through frameworks and libraries. Many of them are open-source. Most of the developers are consumers of such projects. What if we would like to create our own library and distribute it to other developers? We can always create it and share a `*.jar` or `*.aar` file with others. Drawback of such solution is the fact that source of distribution may not be trusted. We also have problems with versioning. Consumers of the library have to constantly download and update their files. It's much better to publish our library to Maven Central Repository and allow others to easily and seamlessly add it as an external dependency to `pom.xml` file (in case of Maven) or `build.gradle` file (in case of Gradle). In such case, dependency is managed by the appropriate build system and distributed via trusted source. This may be not easy for the first time that's why I decided to collect information related to this topic in a single article. Let's see how to do this.

## Generating a GPG Key

Before we upload library, we need to generate GPG key.

In order to generate GPG key, we need to open the terminal and type the following command:

```
gpg2 --gen-key
```

Then, we should see the output:

```
...
gpg: key YOUR_KEY_ID marked as ultimately trusted
...
```

Read more at: https://alexcabal.com/creating-the-perfect-gpg-keypair

## Distributing the public key

Next, we need to distribute public key. We can do that as follows:

```
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys YOUR_KEY_ID
```

We can distribute our key to multiple servers to speed up the synchronization process (pgp.mit.edu, keyserver.ubuntu.com, etc.)

We can also list our keys as follows:

```
gpg2 --list-keys
```

To list secret keys, we can type:

```
gpg2 --list-secret-keys
```

## Preparing the Gradle configuration

In my case, I used Gradle as a build system, which works well for Java, Kotlin and Android projects. We can use Maven for this purpose as well. As a reference, I used [a Gradle script prepared by Chris Banes](https://github.com/chrisbanes/gradle-mvn-push). You can have a look at it in [one of my projects](https://github.com/pwittchen/ReactiveNetwork/blob/RxJava2.x/maven_push.gradle).

In my libraries, I usually have the following structure:

```
/
├── library
│   ├── gradle.properties
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

In the `$HOME/.gradle/gradle.properties` file, I keep system-wide release configuration for Sonatype:

```
signing.keyId=YOUR_KEY_ID
signing.password=YOUR_SIGNING_PASSWORD
signing.secretKeyRingFile=/home/piotr/.gnupg/secring.gpg
 
NEXUS_USERNAME=YOUR_NEXUS_USERNAME
NEXUS_PASSWORD=YOUR_NEXUS_PASSWORD
```

`YOUR_NEXUS_USERNAME` and `YOUR_NEXU_PASSWORD` can be defined during account creation on the http://oss.sonatype.org website.

Of course, you need to provide your own path to `secretKeyRingFile`, which was created during generating key.

If you're interested in the complete project structure prepared for library release, you can have a look at the following examples:
- Java library (compiled into `*.jar` file): https://github.com/pwittchen/kirai
- Android library written in Java (compiled into `*.aar` file): https://github.com/pwittchen/ReactiveNetwork
- Android library written in Kotlin (compiled into `*.aar` file): https://github.com/pwittchen/RxBiometric

## Creating a Jira ticket for Sonatype

We should create a [Sonatype Jira account](https://issues.sonatype.org/secure/Signup!default.jspa) and [a new project ticket](https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134). You can have a look at [my first issue](https://issues.sonatype.org/browse/OSSRH-13199). It took a bit longer in my case, because I needed to adjust package name. 

To avoid my mistakes, have a look at the following guides:
- https://central.sonatype.org/pages/ossrh-guide.html
- https://central.sonatype.org/pages/choosing-your-coordinates.html

Please note, this step is required for the first time only as well as generating keys. After that, we we'll be able to release as many artifacts under the given package name as we want. These steps need to be repeated in the case of registering the new package name.

This is reasonable from the security and stability perspective because random people cannot just override widely used packages what might cause serious problems in many projects around the world.

## Uploading an artifact

Once, we have everything set up, we can go to our project via terminal, and type:

```
./gradlew uploadArchives
```

and wait while artifacts are being uploaded.

## Releasing an artifact

Next, we need to go to the http://oss.sonatype.org website, log in and on the left-hand side, click "Staging Repositories". Then, we need to sort artifacts by date (Updated column), to view the recently updated items. We should find our artifact (it should be on the top) and click it. We can verify its contents to ensure that everything is ok (package name, version, etc.) and then, we should press "Release" on our artifact. Once release is done, we should press "Close" on the artifact.

## Commenting the Jira ticket

When we are done with the previous steps, we should go back to our Jira ticket and provide the comment:

```
I have promoted my first release. Thanks.
```

## Waiting for the Maven sync

After all of these steps, we need to wait for the acceptance from the people from Sonatype and Maven Sync. Maven Sync can take no longer than 48 hours. It's usually faster, but it won't happen immediately after releasing and closing an artifact like in the release of the Python packages.

## Summary

We can see, that release process may be overwhelming and time consuming, but **once we release the first artifact, we can skip most of these steps** like generating keys and creating Jira ticket. We just need to have Gradle or Maven configuration, upload artifacts, release and close them via sonatype website and wait for the Maven Sync. Process of releasing new versions of the same artifact is the same as the first release (excluding mentioned first-time steps). During the next release, we simply need to bump library version in the Gradle configuration before uploading artifacts. In the future, I'm planning to write another article, which shows how to skip manual steps of going to Sonatype website and releasig artifacts via clicking on the page via Gradle plugins, so everything will be automated via CLI.

## Links and references
- https://stackoverflow.com/questions/28846802/how-to-manually-publish-jar-to-maven-central
- https://chris.banes.dev/2013/08/27/pushing-aars-to-maven-central/
- https://dzone.com/articles/deploy-maven-central
- https://central.sonatype.org/pages/gradle.html
- https://central.sonatype.org/pages/apache-maven.html
- https://central.sonatype.org/pages/working-with-pgp-signatures.html
- https://alexcabal.com/creating-the-perfect-gpg-keypair
- https://central.sonatype.org/pages/ossrh-guide.html
- https://central.sonatype.org/pages/choosing-your-coordinates.html
- https://gist.github.com/diegopacheco/13c0754f0ab36482f4f804ef3f05f989
