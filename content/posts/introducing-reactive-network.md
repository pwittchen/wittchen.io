---
title: Introducing ReactiveNetwork
date: 2015-08-10 21:52:00
tags:
- android
- open-source
- rxjava
---

I've recently released [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). It is an open-source Android library listening network connection state and change of the WiFi signal strength with [RxJava](https://github.com/ReactiveX/RxJava) Observables. It's a successor of [Network Events](https://github.com/pwittchen/NetworkEvents) library rewritten with Reactive Programming approach. 

Library is compatible with RxJava 1.0.+ and RxAndroid 1.0.+ and uses them under the hood. Min Android SDK version is 9. 
JavaDoc can be found at: [http://pwittchen.github.io/ReactiveNetwork](http://pwittchen.github.io/ReactiveNetwork). 
Repository is available at: [https://github.com/pwittchen/ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). 

This library is much simpler and easier to use than NetworkEvents. Even code-base is much smaller, but we have to remember that it utilizes powerful RxJava and RxAndroid. RxJava hase huge API and gives a lot of possibilities. That's why I was able to obtain desired result with fewer lines of code. 

Basic library usage is quite simple. E.g if we want to monitor `ConnectivityStatus` (`WIFI_CONNECTED`, `MOBILE_CONNECTED` or `OFFLINE`), we can create the following subscription, which is quite familiar for software developers who already know RxJava: 

```java
new ReactiveNetwork().observeConnectivity(context)
    .subscribeOn(Schedulers.io())
    ... // anything else what you can do with RxJava
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1() {
      @Override public void call(ConnectivityStatus connectivityStatus) {
        // do something with connectivityStatus
      }
});
```

When we want to monitor available WiFi Access Points and we want to get fresh list of them whenever strength of the WiFi Access Points signal changes (e.g. when we are moving with a mobile device around), we can use the following code snippet: 

```java
new ReactiveNetwork().observeWifiAccessPoints(context)
    .subscribeOn(Schedulers.io())
    ... // anything else what you can do with RxJava
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1<List<ScanResult>>() {
      @Override public void call(List<ScanResult> scanResults) {
        // do something with scanResults
      }
});
```

If you want to use ReactiveNetwork in your project, add the following dependency to your `build.gradle` file:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivenetwork:0.0.2'
}
```

Find more in the GitHub repository of the project at: [https://github.com/pwittchen/ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). 
It's worth mentioning that this library was featured on [Android Arsenal](https://android-arsenal.com/details/1/2290), [Android Weekly](http://androidweekly.net/issues/issue-166) and [Android Weekly China](http://androidweekly.cn/android-dev-weekly-issue44/) websites. 
I hope you will find it useful and you will make your apps more reactive! Feel free to fork the library. 
Any feedback is welcome as usual.
