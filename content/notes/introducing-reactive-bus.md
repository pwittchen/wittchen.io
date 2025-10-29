---
title: Introducing ReactiveBus
tags:
  - java
  - rxjava
  - android
date: 2018-03-11 20:02:45
---

Today, I've released my another tiny project. It's a very simple implementation of Event Bus with RxJava 2 under the hood. This library is compatible with Java 1.7 or higher. I didn't use Java 1.8 or 1.9 because I wanted to make it compatible with Android apps.

You can use it as follows:

```java
Bus bus = ReactiveBus.create();

Disposable observer = bus.receive().subscribe(new Consumer<Event>() {
    @Override public void accept(Event event) {
      // handle event here
    }
  });
```

Once, we created Event Bus object and our observer (or more precisely: disposable subscriber), we can start sending events:

```java
bus.send(Event.name("my event").build());
```

We can also send some serializable data:

```java
bus.send(Event.name("my another event with data").data(serializableObject).build());
```

All events, will be received by the consumer in `subscribe(...)` method.

If we want to stop propagation of the events, we can just dispose observer like any RxJava subscription:

```java
observer.dispose();
```

Actually, most of the work is done by RxJava itself. In this project, I just put a few pieces together and played around with them in unit tests.

With such kind of Event Bus implementation, we can create fluent, functional, reactive piplines of data flow in our apps.

You can include this tiny library in your project via Maven:

```xml
<dependency>
    <groupId>com.github.pwittchen</groupId>
    <artifactId>reactivebus</artifactId>
    <version>0.0.5</version>
</dependency>
<dependency>
    <groupId>io.reactivex.rxjava2</groupId>
    <artifactId>rxjava</artifactId>
    <version>2.1.10</version>
</dependency>
```

or via Gradle:

```gradle
implementation 'com.github.pwittchen:reactivebus:0.0.5'
implementation 'io.reactivex.rxjava2:rxjava:2.1.10'
```

For more details, visit project repository on GitHub: https://github.com/pwittchen/ReactiveBus

References
----------
- **Articles**:
  - [Understanding RxJava Subject — Publish, Replay, Behavior and Async Subject](https://blog.mindorks.com/understanding-rxjava-subject-publish-replay-behavior-and-async-subject-224d663d452f)
  - [What's different in RxJava 2.0?](https://github.com/ReactiveX/RxJava/wiki/What%27s-different-in-2.0)
  - [Implementing an Event Bus with RxJava 1](https://blog.kaush.co/2014/12/24/implementing-an-event-bus-with-rxjava-rxbus/)
- **Other Event Bus implementations**:
  - [Otto](https://github.com/square/otto)
  - [Event Bus in Guava](https://github.com/google/guava/wiki/EventBusExplained)
  - [GreenRobot's Event Bus](https://github.com/greenrobot/EventBus)
