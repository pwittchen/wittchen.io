---
title: Creating a Docker container with Alpine Linux including Java 8 and 9
date: 2017-12-27 14:43:00
tags:
	- java
	- docker
	- alpine
	- linux
---

Recently, I've decided to refresh my knowledge regarding [Docker](https://www.docker.com/) and created an image with [Alpine Linux](https://alpinelinux.org/) and Java 9, which can be a useful base for the future projects. I used Alpine as a base image because it became quite popular in the Docker world due to its simplicity and the fact that it's pretty lightweight when we compare it to containers based on other Linux distributions. Pure Alpine Docker container has about 4.144 MB, what is really impressing.

Container with Java 9
---------------------

My `Dockerfile` looks pretty simple:

```docker
FROM alpine:latest
MAINTAINER pwittchen
USER root

RUN wget http://download.java.net/java/jdk9-alpine/archive/181/binaries/jdk-9-ea+181_linux-x64-musl_bin.tar.gz
RUN tar -xzvf *.tar.gz
RUN chmod +x jdk-9
RUN mv jdk-9 /usr/local/share
ENV JAVA_HOME=/usr/local/share/jdk-9
ENV PATH="$JAVA_HOME/bin:${PATH}"
RUN rm -rf *.tar.gz
```

We're downloading JDK, unpacking it, moving to `/usr/local/share` directory, creating `$JAVA_HOME` environmental variable and adding `$JAVA_HOME/bin` to the `$PATH`. After that, we're removing downloaded `*.tar.gz` file. Repository with this project is available at: [https://github.com/pwittchen/docker-alpine-java9](https://github.com/pwittchen/docker-alpine-java9) We can also find it on Docker Hub: [https://hub.docker.com/r/pwittchen/alpine-java9/](https://hub.docker.com/r/pwittchen/alpine-java9/) To pull the image from Docker Hub, just type:

```
sudo docker pull pwittchen/alpine-java9
```

To run it with CLI, type:

```
sudo docker run -i -t pwittchen/alpine-java9
```

Then, we can play around with jshell inside the container:

```
/ # jshell
Dec 27, 2017 1:18:10 PM java.util.prefs.FileSystemPreferences$1 run
INFO: Created user preferences directory.
|  Welcome to JShell -- Version 9-ea
|  For an introduction type: /help intro

jshell> System.out.println("hello from docker!")
hello from docker!
```

This container is not so small and has about 919.2 MB. It contains whole JDK, so probably this size could be reduced.

Container with Java 8
---------------------

I've also created another image with Java 8 (just in case):

```docker
FROM alpine:latest
MAINTAINER pwittchen
USER root

RUN apk update
RUN apk fetch openjdk8
RUN apk add openjdk8
```

We can also find it on the web: GitHub: [https://github.com/pwittchen/docker-alpine-java8](https://github.com/pwittchen/docker-alpine-java8) Docker Hub: [https://hub.docker.com/r/pwittchen/alpine-java8/](https://hub.docker.com/r/pwittchen/alpine-java8/) and pull it from the Docker Hub:

```
sudo docker pull pwittchen/alpine-java8
```

and run it with CLI as follows:

```
sudo docker run -i -t pwittchen/alpine-java8
```

In this case, container has 118.5 MB, which is better result than for the previous container. In this case, we're installing Java 8 for Alpine from official repository, so probably it's already optimized. I hope, you'll find it useful while developing your projects in Java 8 or Java 9.
