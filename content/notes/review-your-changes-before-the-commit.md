---
title: Review your changes in the code before the commit
date: 2017-03-26 22:18:00
tags:
- git
---

Most of the people use git as follows.

1.  they create a feature branch
2.  they make some changes
3.  they add all the changes: `git add -A`
4.  they commit changes: `git commit -m "I've done changes"`
5.  they push it: `git push`

There's a problem with such approach. When we created a lot of changes, it may happen that we forgot to delete something and we pushed some garbage to the remote repository. 

It's better to **review our own changes before the commit**. 

When we've done some changes, instead of typing 

```
git add -A
```

we can type 

```
git add -p
```

It will allow us to review our own changes and approve or disapprove them with typing `y` (yes) or `n` (no). 

After that process, all changes approved by us are "staged". Changes, which are not approved are not staged. We can discard unstaged (and also unapproved) changes by typing `git checkout -- .`. After that, our repository is clean - unwanted changes are discarded & changes, which we approved are staged. Next, we can simply commit & push our changes to the remote repository. 

This approach is, in my opinion, very useful and helps to avoid pushing unwanted code to the remote repository, what will hopefully make your co-workers happy.
