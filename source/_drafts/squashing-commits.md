---
title: Different ways of squashing commits
tags:
    - git
---

While creating a Pull Requests it's good to squash all of our intermediate commits into one to avoid clutter in the git log, simplify analysis and allow for simple code revert when necessary. Some time ago I've found project http://rebaseandsqua.sh/ made by Jake Wharton. It's really useful, handy and allows us to rebase and squash commits quite easily. Some time ago I created a git alias for myself for merging last commits in `.gitconfig`:

```
merge-local-commits = !sh -c 'git reset --soft HEAD~$1' -
```

It works pretty fine, but we need to remember how many commits we want to merge and type a commit message again.

Some time ago I've found another solution to this represented with the following alias:

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

