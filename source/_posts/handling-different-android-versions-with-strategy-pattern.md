---
title: Handling different Android versions with strategy pattern
date: 2017-03-26 22:39:00
tags:
	- android
	- patterns
---

When we're developing Android apps, we have to remember that different users have different versions of the Android OS. Unfortunately, not all of them has the newest version of the system and some of them have older devices with older systems. Some of these devices may be even unsupported because e.g. Google supports their devices like Nexus and Pixel for only 2 years. When we want to reach as many users as possible and make the app available for almost everyone, we have to handle different Android versions. One of the solutions for that problem is **strategy design pattern** (it's also called Policy in Domain-Driven Design). I'm developing an Android open-source library called [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork), which is used for monitoring connectivity with the network in the system. Network monitoring strategies vary between different versions of Android and I wanted to choose an appropriate strategy for appropriate Android version. To do so, I've created `NetworkObservingStrategy` interface:

```java
public interface NetworkObservingStrategy {
  Observable observeNetworkConnectivity(final Context context);
  void onError(final String message, final Exception exception);
}
```

This interface can have many implementations like `LollipopNetworkObservingStrategy`, `PreLollipopNetworkObservingStrategy` and `MarshmallowNetworkObservingStrategy`. Morever, more implementations can be added in the future. After that, we can choose a valid strategy for the concrete version of the system:

```java
public static Observable<Connectivity> observeNetworkConnectivity(final Context context) {
  final NetworkObservingStrategy strategy;

  if (Preconditions.isAtLeastAndroidMarshmallow()) {
    strategy = new MarshmallowNetworkObservingStrategy();
  } else if (Preconditions.isAtLeastAndroidLollipop()) {
    strategy = new LollipopNetworkObservingStrategy();
  } else {
    strategy = new PreLollipopNetworkObservingStrategy();
  }

  return strategy.observeNetworkConnectivity(context);
}
```

That's it. Now, we have the separate code working for Android M, L and all devices with system version lower than L. This approach can also be applied to other areas.