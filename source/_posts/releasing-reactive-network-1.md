---
title: Releasing ReactiveNetwork v. 1.0.0 (paying the technical debt)
tags:
  - android
  - java
  - open-source
date: 2018-06-24 23:39:18
---


Today, I've released next version of my most popular open-source project - [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork). I've released version `0.12.4` for RxJava1.x and version `1.0.0` for RxJava2.x. Please note, RxJava1.x is [no longer officially supported](https://github.com/ReactiveX/RxJava/releases/tag/v1.3.8) and I'm going to follow the same approach in my RxJava-based projects. It's not the first release of this project, but I'm breaking the API and removing existing methods, so I decided to stick to proper versioning standard. I didn't always do it properly in the past, but it's never too late.

## Realization I have tech debt

Except for bumping dependencies and organizational stuff, I've decided to reduce tiny technical debt I created over the time. I kept adding many customizations for observing Internet connectivity and end up having many variants of the same methods with different parameters like these:

```java
Observable<Boolean> observeInternetConnectivity(int interval, String host, int port, int timeout)
Observable<Boolean> observeInternetConnectivity(int initialIntervalInMs, int intervalInMs, String host, int port, int timeout)
Observable<Boolean> observeInternetConnectivity(final int initialIntervalInMs, final int intervalInMs, final String host, final int port, final int timeoutInMs, final ErrorHandler errorHandler)
Observable<Boolean> observeInternetConnectivity(final InternetObservingStrategy strategy)
Observable<Boolean> observeInternetConnectivity(final InternetObservingStrategy strategy, final String host)
Single<Boolean> checkInternetConnectivity(InternetObservingStrategy strategy)
Single<Boolean> checkInternetConnectivity(String host,int port, int timeoutInMs)
Single<Boolean> checkInternetConnectivity(String host, int port, int timeoutInMs, ErrorHandler errorHandler)
Single<Boolean> checkInternetConnectivity(final InternetObservingStrategy strategy, final String host)
```

It's flexible approach, but it has a few drawbacks:
- API users could make mistakes during the usage (especially while providing different parameters of the same type)
- Code readibility is bad
- Code is hard to maintain
- Code is hard to extend (in particular cases it may be even impossible)
- Unit testing is not convenient

That situation leads us into **technical debt**. It's kind of shame and I don't want to have it in my personal open-source projects, which I can almost totally control.

## Paying the tech debt

How to fix this situation? Luckilly, this library is tiny and we can fix it with the **Builder Design Pattern**. This pattern should be applied in each situation in which we have methods with many parameters and part of these parameters may be optional. I've decided to create `InternetObservingSettings` class with internal class representing Builder - `InternetObservingSettings.Builder`. I haven't used traditional builder pattern there. I used approach proposed by [David Moten](https://github.com/davidmoten), which you can check in https://github.com/davidmoten/java-builder-pattern-tricks repository. It's cool trick, which makes code nice to use for the end user.

Now, when we want to customize Internet Observing Settings, we can do it as follows:

```java
InternetObservingSettings settings = InternetObservingSettings
    .initialInterval(initialInterval)
    .interval(interval)
    .host(host)
    .port(port)
    .timeout(timeout)
    .errorHandler(testErrorHandler)
    .strategy(strategy)
    .build();

ReactiveNetwork.observeInternetConnectivity(settings)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new Consumer<Boolean>() {
          @Override public void accept(Boolean isConnectedToInternet) {
            // do something with isConnectedToInternet value
          }
        });
```

Of course, all parameters are optional.
We can do the same for another method returning `Single` RxJava2 type:

```java
Single<Boolean> single = ReactiveNetwork.checkInternetConnectivity(settings);
```

Now, I could finally remove old methods.
Full library source and documentation can be found at: https://github.com/pwittchen/ReactiveNetwork.
That's it! 

I hope my library will be more convenient for users with custom implementation requirements now.

Last, but not least - If you want to contribute to this project, you're more than welcome! :-)
