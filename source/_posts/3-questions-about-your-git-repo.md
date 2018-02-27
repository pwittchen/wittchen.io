---
title: 3 questions about your Git repository
date: 2015-12-28 21:37:00
tags:
	- git
	- python
---

Introduction
------------

Can you answer the following questions about your Git repository?

1.  Does development branch has all changes from master branch?
2.  Is your gitlog a crap?
3.  How old are your branches?

If not, but you want to know answers, you're lucky, because I prepared 3 simple scripts for you, which can help to find it out.

Does development branch has all changes from master branch?
-----------------------------------------------------------

**[git-branch-comparator](https://github.com/pwittchen/git-branch-comparator)** is a python script, which checks if development branch has all changes from master branch in Git repository. Another, easier way to accomplish the same task suggested in comments by Mike (thanks!) is to call simply:

```
$ git pull
$ git branch --contains master --no-merged development
```

When we are working in a Git Flow and critical bug occurs on production, sometimes there is a necessity to create so called hot-fix. We can create separate branch from master branch for this hot-fix and then merge it into master branch or we can commit a change on master branch. Second option is not recommended. After that, we have to remember to merge master branch into a development branch to have our hot-fix in a development version as well and avoid merge conflicts in the future. This python script checks, if all changes made on master branch were also merged into development branch to keep those two branches consistent. We can add it as a job into Jenkins CI server and monitor branches consistency. In addition, release jobs can depend on that job and we can avoid merge conflicts or project unstability before release. 

**source code & documentation**: [https://github.com/pwittchen/git-branch-comparator](https://github.com/pwittchen/git-branch-comparator)

Is your gitlog a crap?
----------------------

**[craplog](https://github.com/pwittchen/craplog)** is a python script, which checks if git git log of the given project is crappy or not. Right now, script is very simple. It just checks if more than half of the commit messages are good. Commit message is considered as good, when it contains more than two words. Of course, this is not the only condition determining the quality of the commit message, but this is early beta version of the script and can be improved later. I've read [a discussion in one of the pull requests to Linux kernel](https://github.com/torvalds/linux/pull/17). It made me think about quality of Git commit messages. Of course, Linux kernel is a specific project and has its own standards. Maybe not all of these standards will be valid for a simpler or less complicated projects. Nevertheless, a lot of people don't pay attention to git commit messages. They put crappy stuff inside them like random letters and numbers or stupid expressions, which has no specific meaning, aren't related to the project or aren't informative enough. In my opinion, good git log is one of the factors determining good quality of the project. Sometimes, we need to browse log to find some changes or analyze project history in order to fix a bug or find important information. It's easier to do it, when git log is good. I've made some of the mentioned mistakes in the past, but I try to avoid them now. 

**source code & documentation**: [https://github.com/pwittchen/craplog](https://github.com/pwittchen/craplog)

How old are your branches?
--------------------------

**[git-aged-branches](https://github.com/pwittchen/git-aged-branches)** is a shell script showing git branches of defined repository with age of their last commit. It works on Mac OS X, Linux and can be helpful while investigating old Git branches to delete. This script does not delete anything! It's just for informational purposes. 

**source code & documentation**: [https://github.com/pwittchen/git-aged-branches](https://github.com/pwittchen/git-aged-branches)

Summary
-------

I hope, some of you will find these tools useful and maybe they'll solve your current problems or help to improve quality of your projects. If you would like to know more details about mentioned projects, check instructions how to use them and their source code, visit linked repositories on GitHub. 

**Note**: Any feedback, new issues or pull requests are appreciated!
