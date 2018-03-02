---
title: Joining lists of RxJava Observables
date: 2017-05-15 20:37:00
tags:
	- java
	- rxjava
---

In [RxJava](https://github.com/ReactiveX/RxJava) we have a few operators for joining Observables. The most common are:

*   [concat](http://reactivex.io/documentation/operators/concat.html)
*   [merge](http://reactivex.io/documentation/operators/merge.html)
*   [zip](http://reactivex.io/documentation/operators/zip.html)

Take a look at the documentation in these links. It has **interactive marble diagrams** showing how the operators work on the streams. You can move marbles along the lines and see how the output stream changes. It really helps to understand how it works. Code snippets in this article are based on RxJava 2.1.0 with JUnit 4.12 and Google Truth 0.32 for unit tests. Let's say, we have the following Observables:

```java
public Observable<String> emitNumbers() {
  return Observable.fromArray("1", "2", "3", "4").delay(1, TimeUnit.SECONDS);
}

public Observable<String> emitLetters() {
  return Observable.fromArray("a", "b", "c", "d");
}
```

We can merge them in the different ways.

[Concat](http://reactivex.io/documentation/operators/concat.html)
-----------------------------------------------------------------

Concat operator _emits the emissions from two or more Observables without interleaving them_. We can perform the following operation:

```java
public Observable<String> concatStreams() {
  return Observable.concat(emitNumbers(), emitLetters());
}
```

The easiest way to verify, how this operator works, is to create exploratory unit test as follows:

```java
@Test
public void shouldConcatStreams() {
  // given
  Observable<String> observable = playground.concatStreams();
  List<String> expectedValues = Arrays.asList("1","2","3","4","a","b","c","d");
  List<String> joinedValues = new ArrayList<>();

  // when
  observable.blockingSubscribe(s -> joinedValues.add(s));

  // then
  assertThat(joinedValues).isEqualTo(expectedValues);
}
```

This operation can be represented graphically as well.

```
         1 --- 2 --- 3 --- 4
                  |
         a --- b --- c --- d
                  |
                  |
                concat
                  |
                 \|/
1 -- 2 -- 3 -- 4 --- a -- b -- c -- d
```

As we can see one stream is appended to another regardless of the execution time of both streams.

[Merge](http://reactivex.io/documentation/operators/merge.html)
---------------------------------------------------------------

Merge operator _combines multiple Observables into one by merging their emissions_. Here we have a similar story, but changed operator:

```java
public Observable<String> mergeStreams() {
  return Observable.merge(emitNumbers(), emitLetters());
}
```

We are writing another unit test:

```java
@Test
public void shouldMergeStreams() {
  // given
  Observable<String> observable = playground.mergeStreams();
  List<String> expectedValues = Arrays.asList("a","b","c","d","1","2","3","4");
  List<String> joinedValues = new ArrayList<>();

  // when
  observable.blockingSubscribe(s -> joinedValues.add(s));

  // then
  assertThat(joinedValues).isEqualTo(expectedValues);
}
```

Merge operation should look like that:

```
         1 --- 2 --- 3 --- 4
                  |
         a --- b --- c --- d
                  |
                  |
                merge
                  |
                 \|/
a -- b -- c -- d --- 1 -- 2 -- 3 -- 4
```

This operator doesn't synchronize the streams and merges them as values are emitted. Numbers are emitted later than letters, so letters are placed in the beginning of the output stream. Try to manipulate marble on the interactive diagram on the [reactivex.io](http://reactivex.io) website to see how it should work.

[Zip](http://reactivex.io/documentation/operators/zip.html)
-----------------------------------------------------------

The last operator, I'd like to discuss in this article is "Zip" operator. Zip _combines the emissions of multiple Observables together via a specified function and emit single items for each combination based on the results of this function_. In simple words, it waits until many observables are emitted and then combines them into a pair (or triple Observable, etc. in the case or more Observables). Now, we need to create a function, which will transform our streams and return combined stream.

```java
public Observable<String> zipStreams() {
  return Observable.zip(emitNumbers(), emitLetters(),
      (s1, s2) -> String.format("(%s,%s)", s1, s2));
}
```

Next, we can verify it with test as usual:

```java
@Test
public void shouldZipStreams() {
  // given
  Observable<String> observable = playground.zipStreams();
  List<String> expectedValues = Arrays.asList("(1,a)","(2,b)","(3,c)","(4,d)");
  List<String> joinedValues = new ArrayList<>();

  // when
  observable.blockingSubscribe(s -> joinedValues.add(s));

  // then
  assertThat(joinedValues).isEqualTo(expectedValues);
}
```

and it can be represented graphically like that:

```
        1 --- 2 --- 3 --- 4
                 |
        a --- b --- c --- d
                 |
                 |
                zip
                 |
                \|/
 (1,a) -- (2,b) --- (3,c) -- (4,d)
```

Now, we have pairs of merged streams.

Summary
-------

Of course, RxJava is complicated library and these methods are not covering all possibilities of merging and combining the Observable streams. Neverhteless, examples in this article are quite basic and may help you to understand how mentioned operators work. After that we can apply the best operator to appropriate situation.

* * *

Reference thread on StackOverflow: [http://stackoverflow.com/questions/28843318/android-rxjava-joining-lists](http://stackoverflow.com/questions/28843318/android-rxjava-joining-lists)
