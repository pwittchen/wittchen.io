---
title: ReactiveNetwork - release of v. 0.2.0
date: 2016-02-11 19:19:00
tags:
	- android
	- java
	- open-source
---

I've recently released new version of [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) library for Android. Here are the fresh **release notes** for [version 0.2.0](https://github.com/pwittchen/ReactiveNetwork/releases/tag/v0.2.0):

*   added possibility to observe WiFi signal level with `observeWifiSignalLevel(context, numLevels)` and `observeWifiSignalLevel(context)` method
*   created `WifiSignalLevel` enum
*   added internet check to parameters of `getConnectivityStatus(context, checkInternet)` method
*   made `getConnectivityStatus(context, checkInternet)` method public
*   changed String variable status in `ConnectivityStatus` enum to description and made it public
*   changed output of the `toString()` method in `ConnectivityStatus` to keep consistency with another enum
*   made `ReactiveNetwork` class non-final
*   bumped Kotlin version in sample app to 1.0.0-rc-1036
*   increased immutability of code of the library
*   updated sample apps and documentation

Thanks to [@llp](https://github.com/llp) and his Pull Request, we are able to [observe WiFi signal level](https://github.com/pwittchen/ReactiveNetwork#observing-wifi-signal-level) AKA [RSSI](https://en.wikipedia.org/wiki/Received_signal_strength_indication) now! 

It's one of the most interesting features in the newest release. We can do it as follows: 

```java
new ReactiveNetwork().observeWifiSignalLevel(context, numLevels)
    .subscribeOn(Schedulers.io())
    ... // anything else what you can do with RxJava
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1<Integer>() {
      @Override public void call(Integer level) {
        // do something with level
      }
});
```

or we can observe an enum value instead of integer: 

```java
new ReactiveNetwork().observeWifiSignalLevel(context)
    .subscribeOn(Schedulers.io())
    ... // anything else what you can do with RxJava
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1<WifiSignalLevel>() {
      @Override public void call(WifiSignalLevel signalLevel) {
        // do something with signalLevel
      }
});
```


`WifiSignalLevel` enum can have the following values:

```java
public enum WifiSignalLevel {
  NO_SIGNAL(0, "no signal"),
  POOR(1, "poor"),
  FAIR(2, "fair"),
  GOOD(3, "good"),
  EXCELLENT(4, "excellent");
  ...
}
```

Any feedback will be appreciated! 

Happy coding!