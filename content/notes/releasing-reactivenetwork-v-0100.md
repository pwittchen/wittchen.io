---
title: Releasing ReactiveNetwork v. 0.10.0
date: 2017-07-20 20:02:00
tags:
- android
- java
- rxjava
- open-source
---

I've recently released [**ReactiveNetwork**](https://github.com/pwittchen/ReactiveNetwork) library v. **0.10.0** for RxJava1.x and RxJava2.x. ReactiveNetwork is an Android library listening network connection state and Internet connectivity with RxJava Observables, which I'm developing for approximately 2 years now. In this version, I've done a few bug fixes and added new features for RxJava2.x version. Below, you can find the release notes: [**Release for RxJava1.x**](https://github.com/pwittchen/ReactiveNetwork/releases/tag/v0.10.0)

*   bumped RxJava1 version to 1.3.0
*   bumped test dependencies
*   created Code of Conduct
*   updated Kotlin version in sample apps
*   added retrolambda to the sample Java app - issue [#163](https://github.com/pwittchen/ReactiveNetwork/issues/163)
*   fixed behavior of network observing in disconnected state - issue [#159](https://github.com/pwittchen/ReactiveNetwork/issues/159)

[**Release for RxJava2.x**](https://github.com/pwittchen/ReactiveNetwork/releases/tag/v0.10.0-rx2)

*   bumped RxJava2 version to 2.1.1
*   bumped test dependencies
*   created Code of Conduct
*   updated unit tests
*   updated Kotlin version in sample apps
*   added retrolambda to the sample Java app - issue [#163](https://github.com/pwittchen/ReactiveNetwork/issues/163)
*   fixed behavior of network observing in disconnected state - issue [#159](https://github.com/pwittchen/ReactiveNetwork/issues/159)
*   added the following methods to ReactiveNetwork class:
    *   `Single<Boolean> checkInternetConnectivity()`
    *   `Single<Boolean> checkInternetConnectivity(InternetObservingStrategy strategy)`
    *   `Single<Boolean> checkInternetConnectivity(String host, int port, int timeoutInMs)`
    *   `Single<Boolean> checkInternetConnectivity(String host, int port, int timeoutInMs, ErrorHandler errorHandler)`
    *   `Single<Boolean> checkInternetConnectivity(InternetObservingStrategy strategy, String host, int port, int timeoutInMs, ErrorHandler errorHandler)`

You can add it to your project via Gradle: **RxJava1.x:**

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivenetwork:0.10.0'
}
```

**RxJava2.x:**

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivenetwork-rx2:0.10.0'
}
```

Now, in RxJava2.x version, we have the possibility to check Internet connectivity once without any pooling with new `Single` type. It may be helpful in the specific use-cases when we're focusing on smaller battery usage, a smaller amount of data being sent over the network and lower number of network connections. I'm planning to publish more real life usage examples of this library in the future articles on this blog. I have plans for a few updates in the next version. If you're interested in this project or you're using it, please stay tuned and keep an eye on it at GitHub.
