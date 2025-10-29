---
title: Automating generation of the on-line documentation for Java library
date: 2018-02-11 10:22:00
tags:
- java
---

Introduction
------------

In one of my open-source projects - [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) I have a documentation in `README.md` file and I have JavaDocs as well. This project is an Android library written in Java and built with Gradle. Moreover, I develop this project on two separate Git branches - one for RxJava1.x and another one for RxJava2.x. Similar convention is in the RxJava repository, so I followed it. After each release I publish documentation and JavaDocs on GitHub pages for both versions. It's kind of boring and repeatable task, so I was wondering if there's any way to automate it.

Generating JavaDocs
-------------------

I have a Gradle task, which does that as follows:

```
./gradlew androidJavadocs
```

and generates JavaDocs in `library/build/docs/javadoc/` directory. I keep generated JavaDocs on `gh-pages` branch in `/javadoc/RxJava1.x/` and `/javadoc/RxJava2.x/` directories. Now, I need to checkout to `RxJava2.x` branch generate JavaDocs, switch to `gh-pages` branch delete contents of `javadoc/RxJava2.x/` directory, copy contents from `library/build/docs/javadoc/` into `javadoc/RxJava2.x/`, commit changes, do the same for `RxJava1.x` branch and push changes. As you noticed, It's a lot of manual work. I've scripted it as follows in my `update_javadocs.sh` file:

```bash
!/usr/bin/env bash

# update javadocs for RxJava2.x
git checkout RxJava2.x
./gradlew clean androidJavadocs
git checkout gh-pages
rm -rf javadoc/RxJava2.x/*
cp -avr library/build/docs/javadoc/* ./javadoc/RxJava2.x
git add -A
git commit -m "updating JavaDoc for RxJava2.x"
rm -rf library/build/docs
echo "javadocs for RxJava2.x updated"

# update javadocs for RxJava1.x
git checkout RxJava1.x
./gradlew clean androidJavadocs
git checkout gh-pages
rm -rf javadoc/RxJava1.x/*
cp -avr library/build/docs/javadoc/* ./javadoc/RxJava1.x
git add -A
git commit -m "updating javadocs for RxJava1.x"
echo "javadocs for RxJava1.x updated"

echo "javadocs for both RxJava1.x and RxJava2.x updated - now you can push your changes"
```

Generating user-friendly documentation
--------------------------------------

I keep my whole documentation for the user in `README.md` file. In order to generate user-friendly website with documentation I used [docsify](https://docsify.js.org). You can install it as follows via `npm`:

```
npm i docsify-cli -g
```

Next, on `gh-pages` branch I've created `docs/RxJava1.x/` and `docs/RxJava2.x/` directories and copied there appropriate `README.md` files from `RxJava1.x` and `RxJava2.x` branches. Next I could go inside each directory and type:

```
docsify init .
```

Docsify generated nice website with documentation gathered dynamically from `README.md` file. After that, I've done a few manual adjustments. Now, the only thing a need to do is to keep `README.md` files updated. That's why I made a script for copying `README.md` files from `RxJava1.x` and `RxJava2.x` branch into appropriate directories on `gh-pages` branch and named it `update_docs.sh`:

```bash
#!/usr/bin/env bash
git checkout gh-pages
git show RxJava1.x:README.md >docs/RxJava1.x/README.md
git show RxJava2.x:README.md >docs/RxJava2.x/README.md
git add -A
git commit -m "updating docs"
echo "docs updated, now you can push your changes"
```

Summary
-------

Now, I have boring process of generating Docs and JavaDocs for two separate Git branches automated and I can simply invoke my scripts:

```
./update_javadocs.sh
./update_docs.sh

git push
```

and that's it! You can see websites with documentation at:

*   [http://pwittchen.github.io/ReactiveNetwork/docs/RxJava1.x](http://pwittchen.github.io/ReactiveNetwork/docs/RxJava1.x)
*   [http://pwittchen.github.io/ReactiveNetwork/docs/RxJava2.x](http://pwittchen.github.io/ReactiveNetwork/docs/RxJava2.x)

and JavaDocs at:

*   [http://pwittchen.github.io/ReactiveNetwork/javadoc/RxJava1.x](http://pwittchen.github.io/ReactiveNetwork/javadoc/RxJava1.x)
*   [http://pwittchen.github.io/ReactiveNetwork/javadoc/RxJava2.x](http://pwittchen.github.io/ReactiveNetwork/javadoc/RxJava2.x)

I hope this article will give some ideas of automating your repeatable tasks.
