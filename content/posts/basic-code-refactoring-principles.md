---
title: Basic code refactoring principles
date: 2017-05-05 23:29:00
---

Introduction
------------

I've recently read a book about _Test Driven Development_ by Kent Beck. It's really good, presents the importance of the TDD and shows how to make a life of the software developer easier. In the TDD we follow _red-green-refactor_ process in which we create a failing unit test, then we fix it and refactor it to make code-base better. There's no golden rule when to refactor or how to refactor code and each project is different, but there are a few principles we may follow when we want to improve our projects through refactoring.

Finding similarities and duplications
-------------------------------------

One of the common _code smells_ is duplication. We should search for the following patterns:

*   Two similar loops » try to merge them into one loop
*   Two similar instructions inside conditional statements » try to unify operations and get rid of the "if" statement
*   Two similar methods » try to unify them and remove one of them
*   Two similar classes » try to unify them and remove one of them
*   and so on...

Perform these operations carefully. If something goes wrong, go one step backward. Sometimes it may be impossible to remove all duplications.

Isolating changes
-----------------

Before we start performing changes, it's good to isolate a piece of code. We can move it e.g. to separate method, perform changes and then inline our method. That could help us avoid breaking the whole system.

Data migration
--------------

If we want to change the meaning of the data, we can temporarily duplicate them, perform changes, update interfaces and then remove original code.

Method extraction
-----------------

If a method in our class is too big (according to _Clean Code_, "too big" is longer than 20 lines), we should find code doing specialized mini-task and extract part of it to a separate method. In IntelliJ IDEA we can use `Ctrl+Alt+M` shortcut or `⌘+Alt+M` on Mac for that.

Method inlining
---------------

Sometimes, we're extracting too many pieces of code to separate methods, what may decrease code readability. If the code inside the method is really simple, so it could be written in a single line or optionally in two lines, we may think about inlining this method. To do so, we should remove method and place code directly in the place where it's called. To perform inlining in IntelliJ, we can use `Ctrl+Alt+N` shortcut or `⌘+Alt+N` on Mac.

Interface extraction
--------------------

When we want to create additional implementations of the operations, which already exists in our code-base, we may extract these operations into the interface. IntelliJ IDEA also has support for that. I'm not sure if there's a shortcut, but you can use `Ctrl+Shit+A` shortcut or `⌘+Shift+A` on Mac to open window with operation search and then type _"extract interface"_. It should work.

Moving method
-------------

It may happen, that our class or interface is becoming too big or it has methods, which are not directly related to this class. In such case, we may simply move one method or a few methods to another, more appropriate class or create a separate class or interface for them.

Object-method
-------------

We may encounter a situation when a specific method has too many parameters. In such case, we may consider creating Object-method. It's some kind of data class, which contains attributes the same as method parameters. It will help us to pass data in our system in a more readable way. We can also connect this solution with a Builder software design pattern.

Adding parameter
----------------

During the time, the business logic of our system is getting bigger and one of our methods need to be extended. In such case, we can add another parameter to it. We may also consider creating another, similar method with just one more parameter. When we're providing API or framework for other developers, we have to remember about proper "deprecated" annotations.

Moving parameter from method to the constructor
-----------------------------------------------

It may happen that we want to move a parameter from the method to a constructor to simplify the logic of the project. In order to that, we can move local variable to a class variable (in IntelliJ IDEA: `Ctrl+Alt+V` shortcut or `⌘+Alt+V` on Mac) and then create constructor with this variable (`Alt+Insert` or `⌘+N` on Mac).

Summary
-------

As we can see, there are a few principles, which we may apply during code refactoring to make our project better. Moreover, most of them are supported by IntelliJ IDEA, which is great IDE. If you're programming in another language than Java and want to have refactoring tools, you should check JetBrains products. Nevertheless, there's no golden rule of refactoring. Sometimes it's better to leave the code as it is. Especially if code-base is huge, the project is in production and there are no unit tests. If you want to know more about principles from this article, read _Test Driven Development_ book by Kent Beck. Probably there are more principles than these described in this article. We should perform refactoring carefully and we need to remember about tests. Everything depends on the concrete project and our situation.
