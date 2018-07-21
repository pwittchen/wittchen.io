---
title: Different ways of squashing commits
tags:
  - git
date: 2018-07-21 11:21:54
---


While creating a Pull Requests it's good to squash all of our intermediate commits into one to avoid clutter in the git log, simplify analysis and allow for simple code revert when necessary. 

## Solution #1

Some time ago I've found project http://rebaseandsqua.sh/ made by Jake Wharton. It's really useful, handy and allows us to rebase and squash commits quite easily. 

We can just call:

```
curl rebaseandsqua.sh | sh
```

then edit our commit messages and push the changes.

## Solution #2

If we want to understand this process and do it manually instead of delegating it to the script from the web, we should perform the following steps:

First, we need to decide how many commits, we want to squash. Let's say 3:

```
git rebase -i HEAD~3
```

We should see something like this in our editor of choice:

```
pick 48d7c25 adding link to vim-jdb plugin in README.md
pick 97376b4 Update README.md
pick a92b5bf adding custom-squash alias to .gitconfig
```

Next, we can decide, which commits we want to squash:

```
pick 48d7c25 adding link to vim-jdb plugin in README.md
squash 97376b4 Update README.md
squash a92b5bf adding custom-squash alias to .gitconfig
```

When, we save it, all of our commits will be squashed into one containing all commit messages.
We can now edit this message with command:

```
git commit --amend
```

You can read more about it in the [official Git documentation](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History).

## Solution #3

Some time ago I created a git alias for myself for merging last commits in `.gitconfig`:

```
merge-local-commits = !sh -c 'git reset --soft HEAD~$1' -
```

We can invoke it with e.g.:

```
git merge-local-commits 3
```

It works pretty fine, but we need to remember how many commits we want to merge, type a commit message and perform commit again.

## Solution #4

Recently I've found another solution to this problem represented with the following alias:

```
custom-squash = "!f(){ git reset --soft HEAD~${1} && git commit --edit -m\"$(git log --format=%B --reverse HEAD..HEAD@{1})\";   };f"
```

It's doing the same thing as previous alias, but it preserves all the commit messages. Thanks to that, we can keep all of our commit messages or delete them and leave just one, which is the most relevant for the given change. When we want to "squash" 3 commits, we can just type:

```
git custom-squash 3
```

and we are ready to override all the intermediate commits with the single commit for the Pull Request:

```
git push -f
```

## Summary

As you can see, there are many ways to squash commits into one. Probably there are another solutions, which are not described in this article. You can pratice them in some kind of "dummy" repo and then, when you'll feel comfortable with it, introduce it in your daily workflow. I hope, now you won't be afraid of squashing your commits :-).
