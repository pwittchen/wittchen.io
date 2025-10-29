---
title: ReactiveNetwork - release v. 0.9.0 with RxJava2.x support
date: 2017-04-11 06:04:00
tags:
- android
- open-source
- rxjava
---

This time, I upgraded my another reactive Android open-source project called [ReactiveNetwork](https://github.com/pwittchen/ReactiveNetwork) to RxJava2.x. Many thanks goes to [@tushar-acharya](https://github.com/tushar-acharya) who performed initial migration to the newer version of RxJava. During migration, I've also created new package `rx2` to avoid potential import conflicts during migration inside Android apps. Besides migration, I've updated sample apps, documentation & JavaDocs on Github pages. You can still use RxJava1.x version and it's available on the branch with that name. To use brand new ReactiveNetwork compatible with RxJava2.x, add the following dependency to your `build.gradle` file:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivenetwork-rx2:0.9.0'
}
```

If you still want or need to use RxJava1.x, use the following dependency:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivenetwork:0.9.0'
}
```

New updates and bug-fixes are on the way. Right now I have [a few issues in the project backlog](https://github.com/pwittchen/ReactiveNetwork/issues). Feel free to contribute to this project and report new issues! Any constructive feedback will be appreciated.
