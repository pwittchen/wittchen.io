---
title: Introducing YaaS Java SDK
date: 2017-05-28 21:24:00
tags:
	- yaas
	- hybris
	- java
	- rxjava
	- open-source
---

Introduction
------------

In my company, there's a concept of so-called "innovation day". I have the possibility to "use" 1 innovation day per 2 development sprints. Last year, I used only 1 day due to the tight release schedule and a lot of work. Now, we are right after release, so I had time to take innovation day once again. I've decided to create [**YaaS Java SDK**](https://github.com/pwittchen/yaas-java-sdk). If you don't know what the [YaaS](http://yaas.io) is, check out my previous article about basic usage of YaaS proxy for the microservice. In a few words, it's a proxy for the microservices with authorization & monitoring capabilities, which allows using other services available on the YaaS market. SDK created by me is really simple, was created in a short period of time and does not cover all features of the YaaS. This SDK allows performing authorized requests to the microservices hidden behind YaaS proxy. Tech stack used for this project is as follows:

*   [Java](https://en.wikipedia.org/wiki/Java_(programming_language)) 8
*   [Gradle](https://gradle.org/)
*   [OkHttp3](http://square.github.io/okhttp/)
*   [RxJava2](https://github.com/ReactiveX/RxJava) with [Reactive Streams](http://www.reactive-streams.org/)
*   [Gson](https://github.com/google/gson)

For unit testing I used:

*   [JUnit](http://junit.org/)
*   [Truth](https://github.com/google/truth)
*   [Mockito](http://mockito.org/)

Quick start
-----------

I wanted to make this SDK as simple as possible so the user can add YaaS integration to the Java application within just a few lines of code.

```java
YaaSProject project = new YaaSProject.Builder()
    .withClientId("YOUR_CLIENT_ID")
    .withClientSecret("YOUR_CLIENT_SECRET")
    .withOrganization("YOUR_ORGANIZATION")
    .withService("YOUR_SERVICE")
    .withVersion("v1")
    .withZone(Zone.EU)
    .build();

Client client = new YaaS(project);

client.get("path/to/your/endpoint")
    .subscribe(response -> System.out.println(response.body().string()));
```

As you can see, it looks really simple and straightforward. In the code snippet above, we've done the following thigs:

1.  Defined YaaS Project with YaaS service
2.  Created YaaS Client
3.  Performed HTTP GET request to the endpoint of the microservice asynchronously
4.  Received and printed body of the HTTP response from the microservice on the current thread as a String

All of that was done with `Single` type from RxJava2, which wraps `Response` type from OkHttp. We have a reactive stream of HTTP response here and we can do with it whatever RxJava2 offers us. Like filtering, mapping, throttling, combining it with other stream and so on. For more information, visit repository of the project at: [https://github.com/pwittchen/yaas-java-sdk](https://github.com/pwittchen/yaas-java-sdk).

Future plans
------------

I have the following plans related to this project, which may be realized when I'll have time:

*   Add more unit tests (I didn't have enough time to cover all cases)
*   Add continuous integration
*   Integrate YaaS with SAP Hybris Backoffice or SAP Hybris Core Platform through this SDK (PoC)
*   YaaS Android SDK (copy YaaS Java SDK, downgrade it to Java 7 & optionally migrate to Kotlin and create sample mobile app)
*   Optionally, add more features to YaaS Java SDK
*   Optionally, deploy an artifact to Maven Central repository
*   Optionally, create SDKs for different programming languages (especially those I don't know well or I don't know at all - just to learn them)

Links
-----

Interesting links related to this article:

*   [Source code of the YaaS Java SDK](https://github.com/pwittchen/yaas-java-sdk)
*   [Basic usage of YaaS as a proxy for the microservice](http://blog.wittchen.biz.pl/basic-usage-of-yaas-as-a-proxy-for-the-microservice/)
*   [YaaS website](https://yaas.io)
*   [SAP Hybris website](http://hybris.com)
