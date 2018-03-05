---
title: Emitting different observables conditionally
date: 2017-05-14 21:44:00
tags:
	- java
	- rxjava
---

Sometimes, we may need to emit different RxJava Observables depending on the specific condition dynamically. Moreover, it's good to do it right without breaking a chain (stream of Observables). We want to combine different Observables together and do not want to nest one subscription inside another subscription because this will lead us to "subscription hell" similar to "callback hell". Luckily RxJava has mechanisms to deal with such problems. In this article, I'm basing my examples on RxJava 2.1.0. Let's say we have two Observables:

```java
public Observable<String> trueObservable() {
  return Observable.fromCallable(() -> "trueObservable");
}

public Observable<String> falseObservable() {
  return Observable.fromCallable(() -> "falseObservable");
}
```

and we have another Observable wrapping `Boolean` value:

```java
public Observable<Boolean> createCondition(boolean returnedValue) {
  return Observable.fromCallable(() -> returnedValue);
}
```

This Observable can emit `true` or `false` depending on the provided parameter. What we want to do is to:

*   emit `trueObservable()` when `createCondition(boolean)` returns `true`
*   emit `falseObservable()` when `createCondition(boolean)` returns `false`
*   emit `falseObservable()` when `createCondition(boolean)` emits empty Observable (default behaviour)

We can do it in the following way:

```java
public Observable<String> emitTrueObservableDynamically() {
  return createCondition(true)
      .defaultIfEmpty(false)
      .flatMap(condition -> condition ? trueObservable() : falseObservable());
}
```

In such case, this method will emit `trueObservable()`. When we change parameter of the `createCondition(boolean)` method to false, Observable will emit `falseObservable()`. When we replace `createCondition(boolean)` method with `Observable.empty()`, method will return `falseObservable()` by default. As we can see, it's easily solved with [flatMap](http://reactivex.io/documentation/operators/flatmap.html) and [defaultIfEmpty](http://reactivex.io/documentation/operators/defaultifempty.html) operators. This is quite useful technique, which we can apply to reactive applications to control our flow without breaking the chain. Please note, it's just an example you can create more complicated constructions and handle more complicated types than just boolean and more than two use cases.

* * *

Reference thread for this article on StackOverflow: [http://stackoverflow.com/questions/34195218/rxjava-exequte-observable-only-if-first-was-empty](http://stackoverflow.com/questions/34195218/rxjava-exequte-observable-only-if-first-was-empty).
