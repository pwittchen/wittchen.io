---
title: Improper data type in Android TextView
date: 2013-03-17 18:57:00
tags: 
    - android
---

Identifying the problem
-----------------------

One of the common mistakes done by Android programmers is using improper data type in _TextView_. Let's have a look on a simple code snippet:

```java
int area;
TextView sampleTextView = (TextView) findViewById(R.id.myTextViewInXml);
sampleTextView.setText(area + " km");
```

Here, we simply set a value of the text in an exemplary _TextView_ and append string value " km" at the end. It can be used with _SeekBar_. For example, when we change value of the _SeekBar_, we can also update value of the text inside the _TextView_. Let's have a look on another example:

```java
int area;
TextView sampleTextView = (TextView) findViewById(R.id.myTextViewInXml);
sampleTextView.setText(area);
```

Here, we don't append string value " km" at the end. In such case, our application will crash. We have to remember, that Java is [strongly typed language](http://en.wikipedia.org/wiki/Strong_typing) and we have to take care about data types. In previous example, we had a cast to the _String_ type, because we appended _String_ value at the end. In the second example, we have only _int_ value, but argument for _setText_ method must be in type of _String_. Method named _setText_ accepts integer values as well and in such case, it will try to find resource with a specified integer identifier generated with R.java file. Resource won't be found and application will crash. We can quickly fix this bug by casting argument of the method to the _String_ type.

Solving the problem
-------------------

There are at least two ways of solving this problem: 

**Solution no. 1**

```java
int area;
TextView sampleTextView = (TextView) findViewById(R.id.myTextViewInXml);
sampleTextView.setText(Integer.toString(area));
```

**Solution no. 2**

```java
int area;
TextView sampleTextView = (TextView) findViewById(R.id.myTextViewInXml);
sampleTextView.setText(area + "");
```
