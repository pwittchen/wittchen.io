---
title: Avoiding merging master to master branch in Git
tags:
  - git
date: 2018-03-25 13:35:06
---


Problem
-------

If you are working with Git Version Control System, probably you have seen a commit messages in your git log like:

```
Merge branch 'master' to 'master'
```

or something similar. You might have even pushed such commits! Don't worry, so did I ;-).
In this article I'm going to explain why is it happenning and how to avoid it.

Such situation happens when you performed changes locally and at the same time someone else performed changes on the same branch as well, commited and pushed them to the remote repository. When you are done with your changes, you committed everything and want to push changes. If there are no conflicts, Git wants you to synchronize local repository with the remote repository. That's why you need to merge changes from the remote master branch into your local master branch. After that you can finally push your changes.

It's shown on the diagram below.

```
another developer ------o---(commit)---o------------------------------------------
                       /|\             |
                        |              |
                       pull          push
                        |              |
                        |             \|/
remote 'master' ----o---o--------------o------x-----------------o-------------o---
                    |                        /|\                |            /|\
                    |                         |                 |             |
                   pull                      push (rejected)   pull          push
                    |                         |                 |             |
                   \|/                        |                \|/            |
you ----------------o-------(commit)----------o-----------------o---(merge)---o----
```

Actually, there's nothing wrong with it, but on the other hand you have "polluted" git log. Imagine everyone is following that approach and your code base changes frequently. After some period of time, you'll get a tons of `merge 'master' to 'master'` messages, which doesn't really tell you anything. It will be hard to navigate through the history of the repository and track changes. Luckily, we can avoid that.

Solution
--------

What to do, when Git wants you to merge remote `master` branch into local `master` branch?
I think there may be various strategies to deal with that. I'm going to show you one approach

### 1. Move your last commit into staging area

```
git reset --soft HEAD~1
```

Now, you removed your last commit, but you have your changes uncommited in staging area.

### 2. Move your changes from staging to unstaged area

```
git reset HEAD -- .
```

Now, you have your changes uncommited and unstaged.

### 3. Stash your changes

```
git stash
```

Now, our changes are stashed. We can list them as follows:

```
git stash list
```

To show what's in the most recent stash, we can type:

```
git stash show -p
```

To view an arbitrary stash, we can type something like:

```
git stash show -p stash@{1}
```

### 4. Pull changes from the remote repository

```
git pull
```

### 5. Apply stashed changes

```
git stash apply
```

### 6. Commit and push your changes

```
git commit -m "my elegant change"
git push
```

Now, we have our local repository synchronized with the remote one. We pushed our local changes and we didn't polluted git log with `merge 'master' to 'master'` commits. If you are not very comfortable with Git, try to practice this in a "test" repo before applying this approach in your production repo.

I hope, this article will help to keep your git log clean.
