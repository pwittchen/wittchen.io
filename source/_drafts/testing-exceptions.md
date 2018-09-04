---
title: Testing exceptions
tags:
    - java
    - testing
---

In Java, we can test exceptions via unit tests in a few different ways. In this article, I'll present common methods of doing that. Nevertheless, I suppose we there are different methods as well.

First method is basically wrapping a method call with try-catch block, assigning an exception to a variable and performing appropriate assertion. In these examples, I'm using JUnit for unit tests and [Truth](https://google.github.io/truth/) for assertions.

```java
@Test
public void shouldTestExceptionWithTryCatch() {
  Exception caughtException = null;

  try {
    throw new RuntimeExcetpion("message");
  } catch (final Exception e) {
    caughtException = e;
  }

  assertThat(caughtException).hasMessageThat().isEqualTo("message");
}
```

In the second method, we can define a type of the thrown exception within the `@Test` annotation. It's useful approach when we don't want to test exception details like message and we care only about the type.

```java
@Test(expected = RuntimeException.class)
public void shouldTestExceptionWithExpectedAnnotation() throws RuntimeException {
  throw new RuntimeException("message");
}
```

Third method allows us to test exception type, message and other details without wrapping method call with try-catch block, what increases code readibility and makes it clear. In order to achieve that, we need `@Rule` annotation and `ExpectedException` object like in the code snippet below. What is important in this example, we have to define assertions in the beginning and invoke method, which will throw an exception after these assertions. It's different order than in a regular unit test.

```java

@Rule
public ExpectedException expectedException = ExpectedException.none();

@Test
public void shouldTestExceptionWithRuleAnnotation() throws RuntimeException {
  expectedException.expect(RuntimeException.class);
  expectedException.expectMessage(EXCEPTION_MESSAGE);
  throw new RuntimeException("message");
}
```

Alternatively, we can try to use [Vavr](https://www.vavr.io/) and `Try` interface.

```java
@Test
public void shouldTestExceptionWithTryCatchAndVavr() {
  final Object object = 
    Try
      .of(this::throwExceptionObject)
      .toOption()
      .getOrElse(new ErrorObject());

  assertThat(object).isInstanceOf(ErrorObject.class);
}

private Object throwExceptionObject() {
  throw new RuntimeException("message");
}

private class ErrorObject {}
```

We can even go crazy and prepare RxJava wrapper for our exception.

```java
private Completable toCompletable(final Runnable runnable) {
  return Completable.create(emitter -> {
    try {
      runnable.run();
      emitter.onComplete();
    } catch (final Exception e) {
      emitter.onError(e);
    }
  });
}
```

and write test like that:

```java
@Test
public void shouldTestExceptionWithRxJava() {
  final Throwable throwable = toCompletable(this::throwException).blockingGet();
  assertThat(throwable).isInstanceOf(RuntimeException.class);
  assertThat(throwable.getMessage()).isEqualTo(EXCEPTION_MESSAGE);
}
```

For sure, it shouldn't be default choice and I wrote it just for a little experiment. Don't treat that as a production-ready code (unless there's a reson you really need something like that).

I think, we can find more ways of testing exceptions. In my opinion, solution with JUnit and `@Rule` annotation is the cleanest and most flexible one among all of the approaches presented here. I also recommend Truth for writing assertions. Nevertheless, libraries like FEST, AssertJ and others, which have fluent interface helping in error analysis are also worth considering in daily usage.

Do you know other (maybe better) approaches of testing exceptions in Java? Share them in comments :-).
