---
title: Dockerizing Hybris
date: 2016-07-27 21:52:00
---

Introduction
------------

A few months ago, I started work at [Hybris](http://hybris.com/), which was acquired by SAP, so our "division" is officially called SAP Hybris. I work in a team developing an extension for Hybris platform with assisting extensions and internal framework. There are many teams around the world developing their own extensions, which are finally integrated and packed into Commerce Suite provided to the clients and partners. We have our own development environment, but sometimes there's need to build and run whole Commerce Suite in the case of system tests, bug reproduction, verification, etc. It's not really hard, but you have to know what to do and you have to perform a lot of steps manually. This is kind of old approach in present days. Moreover, it's really big project, so build and initialization process takes time. You have to download huge zipped package, unpack it, run Gradle script with installation recipe, compile project, run initialization and finally start the server.

Automating work
---------------

I wondered if it's possible to automate mentioned process. Moreover, I wanted to learn more about [Docker](https://www.docker.com/) and create more advanced `Dockerfile` than "hello world", which will be real life use case. That's why I decided to dockerize SAP Hybris Commerce Suite. I called this project [**ydocker**](https://github.com/pwittchen/ydocker) and you can find it at [https://github.com/pwittchen/ydocker](https://github.com/pwittchen/ydocker). Before you start doing anything, you need to remember to install Docker on your system. You can check out my notes about [installation Docker on Linux](https://github.com/pwittchen/learning-docker#installation-on-linux) in [learning-docker](https://github.com/pwittchen/learning-docker) repository. **Note #1**: **It's not official company solution** yet. Right now it's just my personal proof of concept. **Note #2**: I had problems with building and running this Docker container on OS X and I haven't tested it on MS Windows. These systems need to use boot2docker, Docker Toolbox or another approach like that. **I had no problems with it on Linux (Ubuntu 14.04 LTS)**, so this system is recommended if you want to build and run this container successfully. Probably other Linux distributions or Ubuntu versions will handle this as well. **Note #3 (update from 01.10.2016)**: Guys working on Docker improved their software for Mac, so it should work without any problems on this system now. It was tested on OS X El Capitan 10.11.6 and works fine. We just need to get [Docker for Mac](https://docs.docker.com/docker-for-mac/).

Building Docker container
-------------------------

Except for `Dockerfile`, ydocker repository also contains helper script `ydocker`, which has the following parameters:

```
-b    building Docker container
-r    running Hybris Server in Docker container
-c    running Docker container with CLI
-i    showing info about Docker container
-u    showing Commerce Suite Download Url
-d    deleting Docker container
-h    showing help
```

This script uses configuration file `ydocker.conf`, which has the following contents:

```
DOCKER_IMAGE_NAME=sap-hybris-commerce-suite
COMMERCE_SUITE_VERSION=latest
RECIPE=b2c_acc
HOST_PORT=9002
CONTAINER_PORT=9002
```

You can customize this configuration. E.g. choose a different version of the suite, different recipe or change server port.
To build container, you can just type:

```
./ydocker -b
```

Then, provide your credentials and Docker will:

1.  create container based on Ubuntu
2.  install Java 8
3.  set Java 8 as default Java version
4.  install wget
5.  download SAP Hybris Commerce Suite via wget
6.  unpack downloaded SAP Hybris Commerce Suite
7.  remove downloaded zipped package to save some disk space
8.  run configured installation recipe
9.  compile the project
10.  run system initialization

It may take some time. If you have good hardware setup it may take about 30 minutes.

Running Docker container
------------------------

When everything is done, you can run docker image, with the command:

```
./ydocker -r
```

After that, Docker will start the server at `localhost` (`127.0.0.1`) and port `9002`, which is exposed. Commerce Suite will be started in a default configuration, which is not production ready, but is good for testing and demonstration purposes. You need to wait for a few minutes to let the server warm up and then you can open administration console from the browser at `http://127.0.0.1:9002`. In addition, if you want to browse generated configuration or unpacked suite, you can run Docker container with CLI with the following command:

```
./ydocker -c
```

It won't start the server, but allow you to take a look around container via terminal.

Summary
-------

That's it! This proof of concept shows that we can get, build and run complicated and a huge project like SAP Hybris Commerce Suite inside Docker container, automate a lot of manual work and transform old school manual deployment and build process into elegant and standardized Docker container.
