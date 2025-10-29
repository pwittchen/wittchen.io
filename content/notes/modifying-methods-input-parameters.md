---
title: Modifying mehtod's input parameters
tags:
  - java
date: 2019-08-05 18:27:30
---


During maintenance of the legacy projects, I sometimes see constructions like:

```java
void appendFooter(Report report);
```

or

```java
void populate(Data data);
```

I even saw something like this:

```java
void populate(Source source, Target target);
```

What is wrong with these statements?

They're using so called *output argument*. In the examples above, we're passing a `report` or `data` variable, which usually are going to be global variables available in the scope of the whole class. These methods takes them as an argument and modify them. This idea comes from pre-OOP times and could be applied in programs written in C. Nevertheless, in Java, this technique should be avoided and is considered as a **bad practice**.

In Robert C. Martin's "Clean Code" book, it's written:

*Output arguments should be avoided.*

Writing code in such way can implicate many problems. Often we don't know, by looking at the method name, how the method is going to modify the input object. Even when we'll write unit tests for each method, the final behavior may be different because in a concrete data flow, one method can modify input object, then another method can modify the same object in a concrete order what will change the final outcome. In this approach data cannot be immutable and body of the method is tightly coupled to the class and it's attributes, which is bad. The more methods like these, the more unpredictable and harder to test code will become. Moreover, when multiple threads will call these methods, then we can encounter errors related to concurrency or data inconsistency.

**How to fix this problem?**

First of all, we should never use input arguments. Variables used in the methods should be available only in the scode of these methods.

We can rewrite bad examples listed above in the following way:

```java
report.appendFooter(footer);
```

and

```java
final Object value = createValue();
data.setValue(value);
```

and

```java
Source source = createSource();
target.setValue(source);
```

Now, we clearly see where objects are created, data is immutable, input parameters are not modified inside the methods, we don't rely on the global state inside particular methods and all method's variables are available only in the scope of the method.

## References
- https://softwareengineering.stackexchange.com/a/245809/189814
- https://softwareengineering.stackexchange.com/questions/322490/what-is-an-output-argument-as-refered-to-in-martins-clean-code/322495
- https://github.com/denizozger/clean-code#methods
