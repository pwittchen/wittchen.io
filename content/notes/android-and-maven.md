---
title: Android and Maven
date: 2013-01-24 23:50:00
tags:
    - android
---

Overview
--------

### Etymology

Maven, a [Yiddish](http://en.wikipedia.org/wiki/Maven) word meaning accumulator of knowledge.

### What is Maven?

[Maven](http://maven.apache.org/) is a tool that can be used for building and managing any Java-based project with all its dependencies (libraries).

### Maven's objectives

*   Making build process easy
*   Providing uniform build system (Project Object Model)
*   Providing quality project information
*   Providing guidelines for best practices development
*   Allowing transparent migration to new features

Setting up Maven Android projects on MS Windows
-----------------------------------------------

### Configuring environment

1.  You need Eclipse Indigo or Juno installed
2.  Run Eclipse
3.  Install Android Connector for Maven via the Eclipse Marketplace. Select _Help -> Eclipse Marketplace…_ and search for _android m2e_.
4.  Click the Install button next to the Android Connector for Maven that appears and follow the path through the wizard dialog to install the plug-in and its dependencies (including the Android Development Toolkit and the Maven for Eclipse m2e plug-in). Accept the terms-and-conditions and click _Finish_.
5.  Create _ANDROID_HOME_ environmental variable and assign location of the Android SDK into it.

    1.  Click _Start_ button
    2.  Right click on the Computer and choose _Properties_
    3.  Choose _Advanced system settings_
    4.  Click _Environment Variables…_
    5.  Click _New_ below _System variables_ window.
    6.  Variable name should be: _ANDROID_HOME_.
    7.  Variable value should be location of the directory containing Android SDK.

6.  Click OK and save your data.
7.  Go to the following website: [http://maven.apache.org/](http://maven.apache.org/)
8.  Go to the download section ([http://maven.apache.org/download.html](http://maven.apache.org/download.html)) and download Maven (version 3.0.4 is preferred – Binary zip)
9.  Extract zip archive and copy _apache-maven-3.0.4_ directory into _C:_ drive.
10.  Location of the extracted directory should be as follows: _C:\\apache-maven-3.0.4\_
11.  Add _C:\\apache-maven-3.0.4\\bin_ directory to the environmental variable called _Path_
    1.  Click _Start_ button
    2.  Right click on the _Computer_ and choose _Properties_
    3.  Choose _Advanced system settings_
    4.  Click _Environment Variables…_
    5.  Find _Path_ variable and and click _Edit_
    6.  After semicolon (;) add path to the directory containing batch script inside the maven directory which should be as follows: _C:\\apache-maven-3.0.4\\bin_
    7.  Click _OK_ and save your data.
12.  Add _platform-tools_ directory from Android SDK directory to the _Path_ environmental variable respectively.
13.  Click _Start_ button and then choose Run option (click _Windows button + R_ key on your keyboard) and type: _cmd_.
14.  Type: _mvn –v_
15.  The returned output should be as follows:
    *   Apache Maven 3.0.4 (r1232337; 2012-01-17 09:44:56+0100)
        Maven home: C:\\apache-maven-3.0.4\\bin\\..
        Java version: 1.6.0_33, vendor: Sun Microsystems Inc.
        Java home: C:\\Program Files (x86)\\Java\\jdk1.6.0_33\\jre
        Default locale: en_US, platform encoding: Cp1252
        OS name: "windows 7", version: "6.1", arch: "x86", family: "windows"

16.  Now Maven should be properly configured and prepared for deployment of the Android applications.

Importing, building and running sample Maven Android project
------------------------------------------------------------

1.  Download samples from the stable branch on the website: [http://code.google.com/p/maven-android-plugin/wiki/Samples](http://code.google.com/p/maven-android-plugin/wiki/Samples)
2.  Extract downloaded archive.
3.  Open Eclipse IDE.
4.  Import _helloflashlight_ project (as an Android project).
5.  Right click on the project.
6.  Choose an option _Configure -> Convert to Maven Project_.
7.  Dependencies and project configuration are defined in _pom.xml_ file.
8.  Click _Start_ button and then choose Run option (click _Windows button + R_ key on your keyboard) and type: _cmd_.
9.  Go to the directory, where the current project (_helloflashlight_) is located.
10.  Type in the command line: _mvn clean install_
11.  Command from previous point will create _.apk_ file in the target folder.
12.  Type in the command line: _mvn android:deploy_
13.  Command from previous point will install the application via Maven on your Android device or Android emulator (virtual device). If more than one device is available, you can specify the relevant device in your _pom.xml_ file. Maven can also start and stop an Android virtual device automatically for you.
14.  You can start the application via Maven by typing the following command: _mvn android:run_

Summary - Pros & Cons
---------------------

### Pros

*   Uniform build system.
*   No need to search for external libraries.
*   Good quality project information.
*   Transparent migration to new features.
*   Single project configuration for libraries in team work.

### Cons

*   Libraries in the repository are not always up to date.
*   Project configuration takes more time.
*   Mistakes in pom.xml file are not detected by IDE, but can cause fail of the build.
*   Necessity of using CLI (Command Line Interface) in some cases.

Additional resources & references
---------------------------------

1.  [Maven reference book](http://www.sonatype.com/books/mvnref-book/reference/)
2.  [Maven reference book – Android Development Section](http://www.sonatype.com/books/mvnref-book/reference/android-dev.html)
3.  [Maven Android Plugin](http://code.google.com/p/maven-android-plugin/)
4.  [Vogella’s article about Maven & Android](http://www.vogella.com/articles/AndroidBuildMaven/article.html)
5.  [Eclipse plugin for Maven Android projects](http://rgladwell.github.com/m2e-android/)
6.  [Maven repository](http://mvnrepository.com/)
