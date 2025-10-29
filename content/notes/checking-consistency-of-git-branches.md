---
title: Checking consistency of git branches
date: 2015-05-14 15:16:00
tags:
- git
- python
---

Recently I've created a simple Python script, which checks whether 'development' branch has all changes from 'master' branch in a Git repository. It's important when we work in a [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/). Branch inconsistency may occur when change with hot-fix will be committed to 'master' branch and we forget to merge 'master' branch back to 'development' branch to have our hot-fix in a 'development' version of the project as well. We should keep branch consistency to avoid merge conflicts and problems with release of the project in the future. Mentioned script is able to perform necessary validation helping to detect potential problems. Moreover, script can be integrated with the Jenkins CI server and we can execute it from a command line via Jenkins job. When, changes from 'master' won't be merged into 'development', job will fail. In opposite case, job should finish with a success. In a Jenkins job we need to remember to add the following _Additional Behaviours_ in _Source Code Management_ (Git) section:

*   Clean before checkout
*   Wipe out repository and force clone

Usage of this script is quite simple: 

```bash
$ python compare-branches.py <path_to_your_git_repository>
```

Script is open-source and can be found at: [https://github.com/pwittchen/git-branch-comparator](https://github.com/pwittchen/git-branch-comparator)
