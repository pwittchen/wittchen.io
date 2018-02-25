---
title: Adjusting Look and Feel of IntelliJ IDEA and Android Studio on Ubuntu
date: 2015-03-28 16:25:00
tags:
	- intellij
	- ubuntu
	- linux
---

Introduction
------------

**Update**: this is an old post. Right now these problems are no longer valid.

In contrast to MS Windows, default installation of IntelliJ IDEA, Android Studio and other JetBrains IDEs, in my opinion, doesn't look good in Ubuntu with Unity. Unfortunately, adjusting look of my favorite IDE is a common problem right now and it was reported to [JetBrains issue tracker](https://youtrack.jetbrains.com/issue/IDEA-57233). Luckily, we can perform a few tweaks, to improve its look & feel ourselves.

Enabling HUD
------------

Some Java applications don't have Head Up Display (HUD) enabled by default. The same problem occurs in IntelliJ IDEA. I've described that in article about [software for common users on Ubuntu](http://blog.wittchen.biz.pl/software-for-common-users-on-ubuntu/). HUD is characteristic element for Unity environment and it's similar to Apple OS X. I think, it's useful and allows to have more space on the screen. In addition, I wanted my IDE to behave in the same way as other applications. In order to enable HUD, we have to install additional software:

```bash
sudo add-apt-repository ppa:danjaredg/jayatana
sudo apt-get update
sudo apt-get install jayatana
```

**Hint**: We can skip this step if we're using different Windows Manager than Unity (e.g. Gnome).

Font fix
--------

IntelliJ IDEA has problem with font anti-aliasing on Ubuntu. In order to resolve that problem, we need to install Font Fix for Open JDK.

```bash
sudo add-apt-repository ppa:no1wantdthisname/openjdk-fontfix
sudo apt-get update
sudo apt-get install openjdk-7-jdk
```

Preparing run script
--------------------

To finalize font fixing process, we need to prepare additional shell script, place it in the `bin/` directory with the IDE and run IntelliJ IDEA with that script. Below, I present source of my scripts for IntelliJ IDEA and Android Studio. We can create scripts for other JetBrains IDEs (e.g. PyCharm) in the same way. 

```bash
run-idea.sh
```

```bash
#!/bin/sh
# change to your location
IDEA_HOME=/home/piotr/Development/java/idea-ce
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

# Note: Can modify $IDEA_HOME/bin/idea{,64}.vmoptions
# instead of setting here.
# "-Dawt.useSystemAAFontSettings=on" seems worse to me
# "-Dsun.java2d.xrender=true" makes fonts darker
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd \
                      -Dsun.java2d.xrender=true \
                      -Dswing.aatext=true \
		      -Dsun.java2d.pmoffscreen=false"
# Having this set makes menu font size smaller (wtf?)
export GNOME_DESKTOP_SESSION_ID=this-is-deprecated
# unset GNOME_DESKTOP_SESSION_ID
exec $IDEA_HOME/bin/idea.sh "$@"
```

```bash
run-studio.sh
```

```bash
#!/bin/sh
# change to your location
ANDROID_STUDIO_HOME=/home/piotr/Development/android/android-studio
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

# Note: Can modify $ANDROID_STUDIO_HOME/bin/studio{,64}.vmoptions
# instead of setting here.
# "-Dawt.useSystemAAFontSettings=on" seems worse to me
# "-Dsun.java2d.xrender=true" makes fonts darker
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd \
                      -Dsun.java2d.xrender=true \
                      -Dswing.aatext=true \
		      -Dsun.java2d.pmoffscreen=false"
# Having this set makes menu font size smaller (wtf?)
export GNOME_DESKTOP_SESSION_ID=this-is-deprecated
# unset GNOME_DESKTOP_SESSION_ID
exec $ANDROID_STUDIO_HOME/bin/studio.sh "$@"
```

Configuring fonts & appearance
------------------------------

I wasn't satisfied by default font configuration of IntelliJ IDEA and Android Studio, so I updated it a little. In my opinion, it looks better after such operation. You can see my configuration on the screenshots below. Screenshots are from Android Studio, but configuration can be the same for all JetBrains IDEs. Of course, I also prefer Darcula theme. 

![android_studio_font_01](/images/posts/2015/intellij-look-and-feel/android_studio_font_01.png)

![android_studio_font_02](/images/posts/2015/intellij-look-and-feel/android_studio_font_02.png)

Finishing configuration & system reboot
---------------------------------------

When we performed all of the tasks mentioned in the steps above, we need to perform **reboot of the system**. After that, our IDE and its fonts should look fine. That's it. I hope it will be helpful for you.
