---
title: Get past the syntax - the real scare is in the semantics
date: 2015-07-06 15:37:00
tags:
- java
- conferences
---

Dr. [Venkat Subramaniam](http://agiledeveloper.com/) presented an interesting point of view during his talk at Devoxx conference. Programmers, who start learning a new language, often complain about syntax. They focus on using available keywords and constructions instead of trying to understand their meaning and purpose. Programmers also have their own habits. That’s why Java has similar syntax to C and C++. Creators of Java designed new language with syntax, which was familiar to them, with significant improvements. Perception of the world is based on experience and things we get used to. The same rule applies to programming languages. Most software developers are familiar with imperative programming paradigm. They often focus on describing computation in terms of statements and changing program state. This approach leads us to necessity of creating a lot of temporary variables and boilerplate code. Let’s have a look at the following code snippet:

```java
int start = 0;
int limit = 10;
int i = start;
int j = 0;
int[] evenNumbers = new int[limit];
double sum = 0;

while (j < evenNumbers.length) {
  if (i % 2 == 0) {
    evenNumbers[j] = i;
    j++;
  }
  i++;
}

for (int k = 0; k < evenNumbers.length; k++) {
  sum += Math.sqrt(evenNumbers[k]);
}

System.out.println(sum);
view raw

```

This code prints sum of the square roots of the first ten even numbers starting from zero. It’s not so complicated task, but there is a lot of code, temporary variables, two loops, we have to be careful with operators to avoid `ArrayIndexOutOfBoundsException` and so on. Moreover, code is quite hard to analyze and we can make a mistake in many places. Let’s see what happens when we use functional programming approach, Java 8 with stream API and lambdas. We can do the same task in the following way:

```java
int start = 0;
int limit = 10;

double sum = Stream
               .iterate(start, e -> e + 1)
               .filter(e -> e % 2 == 0)
               .map(Math::sqrt)
               .limit(limit)
               .reduce(0.0, Double::sum);

System.out.println(sum);
```

As we can see, the code is simpler, cleaner and easier to analyze. The only difference is the fact that we changed approach from imperative to the functional one and applied different semantics. In this case, instead of focusing on how to do the task, we focused on the result we want to obtain. Instead of learning only syntax, we should spend more time on learning semantics to understand its purpose. This will allow us to create better and robust solutions in less time.

_This article was also published as a part of summary of Devoxx 2015 Conference in Kraków, Poland on technical blog of Future Processing:_ [http://www.future-processing.pl/blog/devoxx-conference-summary/](http://www.future-processing.pl/blog/devoxx-conference-summary/)
