---
title: Get rid of the list null-checks
tags:
    - java
---

During development of the legacy Java applications, we still have to deal with `null`. It's possible to avoid it completly when we're designing application from the scratch, applying proper code constructions, static code analysis and we're consistent during code reviews. Nevertheless in majority of the cases we will encounter `null` in daily projects. We may even expect them in the method inputs and we have to be prepared for it. With the functional programming in Java we can deal with them in quite elegant way, but I often see people are not using features available nowadays.

Let's have a look at the following code snippet:

```java
private List<MyType> getList(final List<MyType> list) {
    if (list != null || list.isEmpty()) {
        return Collections.emptyList();
    }

    return list
            .stream()
            .filter(...)
            .collect(Collectors.toList());
}
```

In this example `list` can be `null`, so we have to perform null-check. We can also verify if the `list` is not empty once we're sure it's not `null` and return empty collection in that case. If the condition is not met, we're converting list to the stream and start processing it.

We can use `CollectionUtils` from Apache Commons library to perform exactly the same check if we have it in our project dependencies:

```java
private List<MyType> getList(final List<MyType> list) {
    if (CollectionUtils.isEmpty(list)) {
        return Collections.emptyList();
    }

    return list
            .stream()
            .filter(...)
            .collect(Collectors.toList());
}
```

We can try to figure out, how to achieve the same goal with functional programming concepts in Java and write the same logic within the single, fluent stream. We can call `Optional.ofNullable(...)` method because we know that our method argument can be `null`. Next, once we've got an `Optional` type, we can call `.orElseGet(...)` method and provide an object, which we want to return, when `nullable` value will be `null`. In this case, it will be an empty list. After that, we can fluently proceed with the stream processing.

```java

private List<MyType> getList(final List<MyType> list) {
    return Optional
            .ofNullable(list)
            .orElseGet(Collections::emptyList)
            .stream()
            .filter(...)
            .collect(Collectors.toList());
}
```

Code snippet above looks much more elegant, it's shorter, more concise and we have achieved our goal within a single stream without any additional `if` statements and without breaking chain of method invocations.
