---
title: Introducing ReactiveBeacons
date: 2015-09-30 19:49:00
tags:
	- android
	- open-source
	- beacons
	- bluetooth
	- ble
---

Recently, I've created yet another reactive library for Android. It's called [ReactiveBeacons](https://github.com/pwittchen/ReactiveBeacons) and it's responsible for observing BLE (Bluetooth Low Energy) beacons. Beacons are small devices, which became quite popular in the last years. They can be utilized in creating Contextual Awareness, Contextual Computing and [Internet of Things](https://en.wikipedia.org/wiki/Internet_of_Things). Beacons have lithium battery, are constantly turned on and emit signals via Bluetooth all the time. ReactiveBeacons library allows to transform these signals into Observable stream compatible with RxJava. Whenever new beacon is detected or [RSSI](https://en.wikipedia.org/wiki/Received_signal_strength_indication) (Received signal strength indication) changes, new immutable beacon data is emitted. 

Usage of the library inside the Activity is simple: 

```java
private Subscription subscription;

@Override protected void onResume() {
  super.onResume();

  // optionally, we can request Bluetooth Access
  reactiveBeacons.requestBluetoothAccessIfDisabled(this);

  subscription = reactiveBeacons.observe()
    .subscribeOn(Schedulers.io())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1<Beacon>() {
      @Override public void call(Beacon beacon) {
        // do something with beacon
      }
    });
} 
```

We also have to remember to unregister subscription correctly in order to stop BLE scan, which can drain the battery.

```java
@Override protected void onPause() {
  super.onPause();
  subscription.unsubscribe();
}

```

If you want to use this library in your project, add the following dependency to your `build.gradle` file.

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivebeacons:0.0.1'
}
```

Don't forget to add dependency to [RxAndroid](https://github.com/ReactiveX/RxAndroid) if you want to use Android-specific features of RxJava. 

Source code of the library can be found at: [https://github.com/pwittchen/ReactiveBeacons](https://github.com/pwittchen/ReactiveBeacons). 

Any new issues or pull requests are welcome! 

Happy coding!