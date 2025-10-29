---
title: Basics of Git
date: 2014-11-27 21:49:00
tags:
- git
---

Introduction
------------

[Git](http://git-scm.com/) is very popular Version Control System used in many software projects today. In my opinion, it's the best VCS available today. In order to start your adventure with this tool, you should know its basic commands and features. There are graphical tools, which allows to use Git without terminal, but I recommend you to use terminal. With CLI you can work faster, you can understand Git better and you have more control over your repository.

Basic commands
--------------

In my opinion, list presented below contains commands, which are used on daily basis and you should start journey with them. 

```
git help                      # shows git commands
git init                      # creates git repository in current directory
git add -A                    # adds all files in current directory to repository
git commit -m "message"       # commits changes with specific message
git push                      # pushes committed changes to remote repository on server
git status                    # checks current status of the local repository
git pull                      # pulls updates from remote repository
git fetch                     # fetches changes from remote repository
git fetch -p                  # fetches changes with "prune" option removes local copies of deleted "remote" branches
git checkout my_branch        # switches to branch named "my_branch"
git checkout -b my_branch     # creates local branch named "my_branch"
git branch --delete my_branch # removes local branch named "my_branch"
git push origin --delete      # removes remote branch named "my_branch"
git branch                    # displays local branches
git branch -a                 # displays all branches (local and remote)
git merge my_branch           # merges branch named "my_branch" into branch on which we are checked out
git stash                     # creates stash with currently saved changes on current branch
git stash list                # displays list of stashes
git stash apply               # applies stash with previously saved changes
git reset --hard              # discards all uncommitted local changes
git reset <file>              # removes <file> added to repository from current index ("about to be committed" area)
git revert commit_name        # creates new commit, which undoes all changes introduced in commit named commit_name
git revert HEAD               # reverts commit we just created with additional "revert commit"
git reset --hard HEAD^        # reverts last commit without additional "revert commit"
git rebase my_branch          # pulls changes from "my_branch" to branch on which we are checked out without making commit
git log                       # displays log of the commits in repository
git remote -v # gets address of the remote repository
```

Git hist
--------

There is one more fancy feature, which allows you to display colorful and graphical representation of branches and commits. 

```
log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
```


You can assign this command to `hist` alias in your `.gitconfig` file. After that, you can type: `git hist` and this command will be executed. More advanced commands and features can be mastered after some work with basic Git stuff.

Resolving conflicts
-------------------

It may happen that someone modified file and pushed changes into repository and after that we modified the same file in the same place and want to push our changes. In such case, we have to resolve conflicts and merge changes. Sometimes, its more convenient to resolve conflicts with graphical tools than editing raw files modified by Git. If you are using IDE provided by JetBrains (e.g. IntelliJ IDEA or Android Studio) you can use VCS tools built-in IDE. Just choose option `VCS -> Git -> Merge changes...` for program menu and you can merges via graphical interface. There are also other tools like Kdiff3 or Meld, but I personally prefer JetBrains tools.

Git flow
--------

Last, but not least, remember to read about **Git workflow** and familiarize yourself with that concept:

*   [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
*   [Understanding GitHub flow](https://guides.github.com/introduction/flow/index.html)

Further learning
----------------

There are many Git tutorials and materials worth reading, which can help with extending knowledge about this VCS:

*   [Git documentation](http://git-scm.com/doc)
*   [Pro Git book](http://git-scm.com/book/en/v2)
*   [Git Immersion](http://gitimmersion.com/)
*   [Git tutorial by Atlassian](https://www.atlassian.com/git/tutorials/)
