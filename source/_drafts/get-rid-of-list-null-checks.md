---
title: Get rid of list null-checks
tags:
    - java
---

TBD. -> write some description

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
