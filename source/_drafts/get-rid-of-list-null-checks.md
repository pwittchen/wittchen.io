---
title: Get rid of list null-checks
tags:
    - java
---

TBD. -> write some description

```java
...

if (CollectionUtils.isEmpty(list)) {
    return Collections.emptyList();
}

return list
        .stream()
        .filter(...)
        .collect(Collectors.toList());

...      
```

```java
...

return Optional
        .ofNullable(list)
        .orElseGet(Collections::emptyList)
        .stream()
        .filter(...)
        .collect(Collectors.toList());

...
```
