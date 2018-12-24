---
title: Kyma meets CCV2 hackathon summary
tags:
  - kyma
  - hackathon
  - sap
  - hybris
  - kotlin
date: 2018-12-14 14:34:01
---


## Introduction

I recently I had an opportunity to join "Kyma meets CCV2 Hackathon" in the [SAP Labs Poland](https://www.sap.com/poland/index.html) office in Gliwice. The goal of the hackathon was to create a simple project, which will use [Kyma](https://github.com/kyma-project/kyma) to integrate external services with the [SAP Hybris Commerce Platform](https://cx.sap.com/en/products/commerce). CCV2 stands for "Commerce Cloud Version 2", which are basically SAP Hybris Commerce solutions deployed on the MS Azure Cloud (that's a long story described in a short way). I joined a team consisting of people from a few different departments in the office, so we didn't actually know each other before the event. We decided to create a simple application consisting of a few microservices, which will send an e-mail with a promotional link to the user once he or she add something to the cart in the on-line shop. After clicking on the link sent via the e-mail, user will be redirected to the front-end application, where he or she has to click on the button as many times as possible in a given period of time.

![](/images/posts/2018/kyma-meets-ccv2-hackathon-summary/clickr_frontend.png)

The more clicks were performed, the higher discount user will get, but not higher than 20%. When game is finished, front-end application is sending a request to the voucher service from which we can retrieve a promotional code. 

![](/images/posts/2018/kyma-meets-ccv2-hackathon-summary/clickr_frontend2.png)

With this code, we can go to the SAP Hybris Commerce store-front...

![](/images/posts/2018/kyma-meets-ccv2-hackathon-summary/storefront1.png)

...and get our discount!

![](/images/posts/2018/kyma-meets-ccv2-hackathon-summary/storefront2.png)

## Application overview

General concept of the application flow is presented on the diagram below.

![](/images/posts/2018/kyma-meets-ccv2-hackathon-summary/diagram.png)

We decided to create three microservices:
- mailing service written in Node.js
- front-end application with clicking game written in JavaScript
- voucher service written in Kotlin

All microservices needed to have corresponsing Docker containers, which were deployed to the Kyma instance. Kyma was communicating with SAP Hybris Commerce platform written in Java. Thanks to clear separation of a different environments, we were able to integrate services using different technologies.

## Creating a microservice

I was responsible for writing voucher storage microservice. On daily basis I use Java programming language, but I wanted to try something new, so I chose Kotlin. Kotlin is a JVM language, so it runs on the same runtime as regular Java applications. Moreover, I could use tools I'm familiar with like IntelliJ, Gradle, etc. In my microservice I used [Gradle](https://gradle.org/) as a build tool, [Javalin](http://javalin.io/) for designing REST API and [Dagger](https://github.com/google/dagger) for Dependency Injection. Moreover, for writing unit tests I used [JUnit](https://junit.org), [JUnitParams](https://github.com/Pragmatists/JUnitParams), [Truth](https://github.com/google/truth) and [Mockito](https://github.com/mockito/mockito). I also wrote a few integration tests for the API with [REST Assured](https://github.com/rest-assured/rest-assured). As you can see, I could easily use Java libraries in the Kotlin application because those two languages are fully interoperable.

REST API definition of my application looks pretty simple:

```kotlin
class Application {
  companion object {
    private val logger = LoggerFactory.getLogger(Application::class.java)
    private val component = DaggerApplicationComponent.create()
    private val voucherController = component.voucherController()
    private val voucherHttpFacade = component.voucherHttpFacade()

    @JvmStatic fun main(args: Array<String>) {
      Javalin
          .create()
          .enableCorsForAllOrigins()
          .requestLogger { ctx, time ->
            logger.info("${ctx.method()} ${ctx.path()} ${ctx.status()} took $time ms")
          }.routes {
            get("/voucher") { voucherHttpFacade.getAll(it) }
            get("/voucher/:group") { voucherHttpFacade.getGroup(it) }
            get("/health") { it.json(Health("UP")).status(HttpStatus.OK_200) }
            get("/") { it.status(HttpStatus.FORBIDDEN_403) }
          }
          .event(JavalinEvent.SERVER_STARTING) { voucherController.loadVouchers() }
          .start(7000)
    }
  }
}
```

I have an endpoint for gathering all vouchers, gathering single voucher for a given group and deactivating it and health-check. In addition, I'm loading all the vouchers into the application memory on the server startup using [Kotlin coroutine](https://kotlinlang.org/docs/reference/coroutines-overview.html) under the hood asynchronously.

```kotlin
override fun loadVouchers() {
  GlobalScope.async { loadVouchersFromAllGroups() }
}
```

Application can be build with Gradle as follows:

```
./gradlew build
```

I'm using [Shadow Gradle plugin](https://github.com/johnrengelman/shadow) to create fat jar. Once, build is finished, I can start the application with embdedded Jetty HTTP server on the port 7000.

```
java -jar build/libs/app-1.0-all.jar
```

You can find source code of the whole application at: https://github.com/pwittchen/voucher-storage-service.

## Deployment of the microservice

In order to deploy the microservice to the Kyma, I needed to prepare `Dockerfile`, which looks as follows:

```Dockerfile
FROM openjdk:8-jre-alpine
MAINTAINER pwittchen
WORKDIR /app
COPY build/libs/app-1.0-all.jar .
RUN ls -la /app
CMD java -jar app-1.0-all.jar
```

It's just a lightweight Alpine Linux with Java 8 and Kotlin application compiled into fat jar.

To build the container, I invoked command:

```
sudo docker build -t pwittchen/voucher-storage-service .
```

and to run it, I invoked command:

```
sudo docker run -p 127.0.0.1:7000:7000 -t pwittchen/voucher-storage-service
```

I also pushed it to the [docker hub](https://hub.docker.com/r/pwittchen/voucher-storage-service/) because Kyma gets required containers from there.

Next, I created `deployment.yml` file for Kubernetess, which is used by Kyma under the hood.

```yml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: voucher-storage-service
  labels:
    app: voucher-storage-service
spec:
  selector:
    matchLabels:
      app: voucher-storage-service
  template:
    metadata:
      labels:
        app: voucher-storage-service
    spec:
      containers:
        - name: web
          image: docker.io/pwittchen/voucher-storage-service:latest
          ports:
            - containerPort: 7000
---
apiVersion: v1
kind: Service
metadata:
  name: voucher-storage-service
  labels:
    app: voucher-storage-service
spec:
  ports:
  - name: http
    port: 7000
  selector:
    app: voucher-storage-service
```

Such configuration had to be provided for Kyma by all microservices.

## Summary

Once, we deployed all the microservices and tested the whole flow, we needed to apply a few adjustments. When issues were fixed, whole application worked correctly. This proves that external services written in different technologies can be integrated with SAP Hybris Commerce using Kyma. This hackathon was pretty nice experience, learning opportunity and productive distraction from daily projects. Moreover, our team won the whole event ex aequo with another team located in Germany. Thanks to this hackathon, I have better understanding of Kyma and integration tooling for the SAP Hybris Commerce platform.
