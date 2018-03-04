---
title: Simple reactive HTTP client and server with RxJava, Vert.x and Android
date: 2017-11-09 22:30:00
tags:
	- android
	- java
	- rxjava
	- vertx
	- http
	- client-server
---

During [Hack Your Career](https://www.facebook.com/Hack.your.Career/) event at the Silesian University of Technology, I've prepared a presentation titled [Reactive Programming - Efficient Server Applications](https://speakerdeck.com/pwittchen/reactive-programming-efficient-server-applications) with a colleague from work. Arek told about theory of Reactive Programming, shown basic concepts, data types and a few examples in the code. During my part of the presentation, I've wrote a very simple server and client in Java (9 on the server, 7 on the client) with [Vert.x](http://vertx.io/) ([Core](http://vertx.io/docs/vertx-core/java/) and [Rx](http://vertx.io/docs/vertx-rx/java2/)), [RxJava 2](https://github.com/ReactiveX/RxJava), [OkHttp 3](https://github.com/square/okhttp), [Android](https://www.android.com/) and [RxAndroid](https://github.com/ReactiveX/RxAndroid/). Presentation was targeted mainly to the university students with no experience with reactive programming, but it was an open event and anyone could attend it. Below, we can see a very simple code snippet showing how to create a reactive HTTP server with Vert.x. We can create a stream of requests, make `Flowable` out of it, apply any kind of RxJava 2 operator including backpressure handling and subscribe the stream. Moreover, we can also reactively start the server with `rxListen(int port)` method. This is just a basic example, where will be sending request to the only one endpoint. In the case, when we want to handle more endpoints, we can use [vertx-web](http://vertx.io/docs/vertx-web/java/) library and design REST API.

```java
final HttpServer server = Vertx
    .vertx()
    .createHttpServer();

server
    .requestStream()
    .toFlowable()
    .onBackpressureDrop()
    .subscribe(request -> {
      logger.info("{} {}", request.rawMethod(), request.absoluteURI());
      request.response().end("request received");
    });

server
    .rxListen(8080)
    .subscribe(httpServer -> logger.info("server is running at port 8080..."));
```

We can build this server with Gradle as follows:

```
./gradlew shadowJar
```

and then, we can run it:

```
java -jar build/libs/server-fat.jar
```

Our client will be an Android application, which will read data from the accelerometer sensor, send it to the server and display it in the `TextView` on a mobile device. We will use [ReactiveSensors](https://github.com/pwittchen/ReactiveSensors) library (which was recently migrated to RxJava 2) for getting sensor readings as a `Flowable` data stream. Next, we will apply backpressure `DROP` strategy, filter only events of changing sensors (we neglect changing of the accuracy), read only one event per one second with `throttleLast(int, TimeUnit)` operator and map event to a String with device coordinates. Next, we are ready to send data with `Completable performRequest(String)`, which we created earlier. Sensors readings are acquired in the `computation()` scheduler, send to the server with `io()` scheduler and passed to the UI thread on Android with `AndroidSchedulers.mainThread()`. Distributing operations to the different schedulers is made with `subscribeOn(Scheduler)` and `observeOn(Scheduler)`.

```java
reactiveSensors
    .observeSensor(Sensor.TYPE_ACCELEROMETER)
    .onBackpressureDrop()
    .filter(ReactiveSensorFilter.filterSensorChanged())
    .throttleLast(1, TimeUnit.SECONDS)
    .map(this::getSensorReading)
    .doOnNext(event -> performRequest(event)
        .subscribeOn(Schedulers.io())
        .subscribe())
    .subscribeOn(Schedulers.computation())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(event -> tvReadings.setText(event));
```

It's worth noticing that `Completable performRequest(String)` is using OkHttp 3 under the hood as a HTTP client, because it's very simple example with one endpoint. In the case, we want to handle more endpoints on the client-side, it's better to use [Retrofit](https://github.com/square/retrofit) library. It's also interesting that in our case, we can simulate behavior of the accelerometer and other sensors with the latest Android device emulator available in the Android SDK. It works surprisingly smooth. 

![](/images/posts/2017/simple-reactive-http-client-and-server-with-rxjava-vertx-and-android/virtual_sensors.png)

**Complete working example can be found at**: [https://github.com/pwittchen/reactive-client-server](https://github.com/pwittchen/reactive-client-server). Later, I've also shown, how to use RxJava to distribute computational operations to a different threads of the CPU cores, but I'll probably publish a separate article about that on this blog. It was the same example I shown during my JDD presentation this year. 

Slides from my part of the presentation are available below.

{% raw %}

<script async class="speakerdeck-embed" data-id="8acf7df50ffc461c8b0e3a6f03199767" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

{% endraw %}

[View slides on SpeakerDeck](https://speakerdeck.com/pwittchen/reactive-programming-efficient-server-applications)