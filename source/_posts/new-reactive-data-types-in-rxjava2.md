---
title: New reactive data types in RxJava2
date: 2017-05-31 17:49:00
tags:
	- java
	- rxjava
---

Introduction
------------

I'm still exploring reactive programming world and RxJava library. Recently, I've migrated a few of my open-source libraries from RxJava1 to RxJava2 and written yet another project in RxJava2 from the beginning. Nevertheless, I'm still learning this library and its concept. It's very wide topic. In RxJava1 we simply had one reactive data type called `Observable`. In RxJava2, we have more data types like `Observable`, `Flowable`, `Single`, `Maybe` & `Completable`. In this article, I'll briefly explain their purpose and tell you when to use which. The general idea behind these types is code semantics. We should tell consumer of our code, what he or she can expect from our API. Introducing more reactive data types can increase readability and stability of our code base.

[Observable](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Observable.html)
---------------------------------------------------------------------------------

`Observable` is basically the same Reactive type, we had in RxJava1. **It doesn't have [backpressure](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#backpressure) support**. We should use `Observable`, when:

*   our data source emits less than 1000 items, so there's practically no chance of occurring `OutOfMemoryException`
*   we are working with GUI events, which usually don't occurs very often and don't have to be backpressured
*   we are working with synchronous code on legacy JVM like Java 1.6 and we want to have streams features like in Java 8

![Observable](/images/posts/2017/new-reactive-data-types-in-rxjava2/observable-644x319.png)

[Flowable](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html)
-----------------------------------------------------------------------------

`Flowable` type has very similar semantics to `Observable`. We can operate on `Flowable` streams with map, flatmap, filter, etc. in the same way as on the `Observable` type. The main difference is **[backpressure](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#backpressure) support**. We should use `Flowable` when we are:

*   dealing with 10k+ elements in a stream
*   dealing with frequent events (e.g. sensors readings)
*   reading/parsing files from disk
*   reading values from database through JDBC
*   using network/streaming I/O
*   reading/writing to many blocking or pull-based data sources

To learn more, read note about [Observable vs. Flowable](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#observable-and-flowable) on wiki of RxJava2 on GitHub.

[Single](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Single.html)
-------------------------------------------------------------------------

`Single` reactive type has been redesigned from scratch in RxJava 2. It's designed to handle just one event in an asynchronous manner. Good application of this type is single HTTP request when we expect just one response or error and nothing else. It can emit on `onSuccess` (single value) or `onError` event (error). 

![Single](/images/posts/2017/new-reactive-data-types-in-rxjava2/single-644x303.png)

[Maybe](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Maybe.html)
-----------------------------------------------------------------------

`Maybe` represents a deferred computation and emission of a maybe value or exception. `Maybe` is a wrapper around an operation/event that may have either:

*   A single result
*   Error
*   No result

Just take a look at the scheme. The interface of the main consumer of this type have the following methods: `onSuccess`, `onError`, `onComplete`. Conceptually, `Maybe` is a union of `Single` and `Completable` providing the means to capture an emission pattern where there could be 0 or 1 item or an error signaled by some reactive source. 

![Maybe](/images/posts/2017/new-reactive-data-types-in-rxjava2/maybe.png)

[Completable](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Completable.html)
-----------------------------------------------------------------------------------

`Completable` type can be used when we have an `Observable` that **we don't care about the value resulted from the operation** (result is void). It handles only `onComplete` and `onError` events. Conceptually, `Maybe` is a union of `Single` and `Completable` providing the means to capture an emission pattern where there could be 0 or 1 item or an error signalled by some reactive source. Read more about `Maybe` type on [RxJava wiki](https://github.com/ReactiveX/RxJava/wiki/What%27s-different-in-2.0#maybe).

Summary
-------

As we can see, RxJava2 gives us new types, which can help explain our intentions more clearly. We can adjust concrete type to the specific situation. In addition, we can use backpressure for the data sources, which emit a lot of elements to make our projects more robust and stable. Last, but not least RxJava2 is compatible with [Reactive Streams](http://reactive-streams.org) API, which is going to be part of the Java 9 specification.

References
----------

*   [JavaDoc for RxJava2](http://reactivex.io/RxJava/2.x/javadoc/)
*   [What's diffferent in 2.0?](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0)
*   [StackOverflow Thread: What is the difference between Observable, Completable and Single in RxJava?](https://stackoverflow.com/questions/42757924/what-is-the-difference-between-observable-completable-and-single-in-rxjava)
*   [StackOverflow Thread: What's the difference between RxJava2's Maybe and Optional?](https://stackoverflow.com/questions/40439579/whats-the-difference-between-rxjava2s-maybe-and-optional)
*   [Clearer RxJava intentions with Single and Completable](https://android.jlelse.eu/making-your-rxjava-intentions-clearer-with-single-and-completable-f064d98d53a8)
*   [Blog of Akarnokd (one of the main RxJava contributors)](http://akarnokd.blogspot.com/)
*   [RxJava GitHub repository](https://github.com/ReactiveX/RxJava)
*   [ReactiveX](http://reactivex.io/)
*   [Reactive Programming with RxJava (O'Reilly Media Book)](http://shop.oreilly.com/product/0636920042228.do)
*   [Reactive Streams](http://www.reactive-streams.org/)
*   [Reactive Manifesto](http://www.reactivemanifesto.org/)
