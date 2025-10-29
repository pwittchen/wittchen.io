---
title: How to update forked GitHub repository?
date: 2014-11-07 12:29:00
tags:
- git
---

When you fork GitHub repository, you usually want to have your fork up to date with the original repository.
You can update your fork in a few easy steps. Just look at the following example of the Git commands:


Add the remote, call it `upstream`:

```
git remote add upstream https://github.com/whoever/whatever.git
```

Fetch all the branches of that remote into remote-tracking branches,
such as upstream/master:

```
git fetch upstream
```

Make sure that you're on your master branch:

```
git checkout master
```

Rewrite your master branch so that any commits of yours that aren't already in upstream/master are replayed on top of that other branch:

```
git rebase upstream/master
```

Original post with solution: http://stackoverflow.com/a/7244456
