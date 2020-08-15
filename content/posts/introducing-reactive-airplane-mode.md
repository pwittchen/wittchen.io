---
title: Introducing ReactiveAirplaneMode
date: 2017-08-15 19:28:00
tags:
- android
- java
- rxjava
- open-source
---

I'm continuing _Rxfication_ of the Android. Recently I released brand new library called [**ReactiveAirplaneMode**](https://github.com/pwittchen/ReactiveAirplaneMode). As you may guess, it allows listening Airplane mode on Android device with RxJava observables. A usual I've hidden all implementation details, BroadcastReceivers and rest of the Android related stuff behind RxJava abstraction layer, so API is really simple. Just take a look on that:

```java
ReactiveAirplaneMode.create()
    .observe(context)
    .subscribeOn(Schedulers.io())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(isOn -> textView.setText(String.format("Airplane mode on: %s", isOn.toString())));
```

In the code above **subscriber will be notified only when airplane mode changes**. If you want to **read airplane mode and then listen to it**, you can use the following method:

```java
ReactiveAirplaneMode.create()
    .getAndObserve(context)
    .subscribeOn(Schedulers.io())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(isOn -> textView.setText(String.format("Airplane mode on: %s", isOn.toString())));
```

If you want to **check airplane mode only once**, 
you can use `get(context)` method, which returns `Single<Boolean>` value:

```java
ReactiveAirplaneMode.create()
    .get(context)
    .subscribeOn(Schedulers.io())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(isOn -> textView.setText(String.format("Airplane mode on: %s", isOn.toString())));
```

If you want to **check airplane mode only once without using Reactive Streams**, just call `isAirplaneModeOn(context)` method:

```java
boolean isOn = ReactiveAirplaneMode.create().isAirplaneModeOn(context);
```

You can add this library to your project via Gradle:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactiveairplanemode:0.0.1'
}
```

If you want to know more details, see sample app, documentation & tests, check repository with the source code at: [**https://github.com/pwittchen/ReactiveAirplaneMode**](https://github.com/pwittchen/ReactiveAirplaneMode).