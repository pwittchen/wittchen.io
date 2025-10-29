---
title: My approach to Git aliases
date: 2017-03-12 13:20:00
tags:
- git
---

While we are working with Version Control Systems like Git, it's good to adapt them to our needs to perform daily work in a more productive way. People often create so-called Git aliases, which are shortcuts for longer commands. E.g. you can edit your `.gitconfig` file, which is usually located in your home directory and place a few aliases in the `[alias]` section. For example:

```
[alias]
  ls = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate
```

Then you can type: `git ls` in your Git repository to see pretty Git log. Sometimes people go further and create many more aliases like:

```
cp = cherry-pick
st = status
cl = clone
ci = commit
co = checkout
br = branch
```

and so on. I've seen configurations containing about **20 aliases or more** consisting of shortcuts, which have 2 or 3 letters. Usually, we don't use 20 commands every day. I can remember e.g. 5 shortcuts, but I don't want to remember more. Instead of alias:

```
lcm = log -1 --pretty=%B
```

I prefer:

```
last-commit-msg = log -1 --pretty=%B
```

When I'm using terminal on Linux or macOS, I have type hinting, so I can type: `git la`, hit `Tab` and terminal will autocomplete my command to `git last-commit-`. Then I can hit `Tab` again and I can choose one of my aliases and select one by hitting `Enter`. ![git alias hints in unix terminal](/posts/2017/my-approach-to-git-aliases/git-alias-hint.png) Now, I don't have to remember all of my aliases. **I treat my `.gitconfig` file as a documentation**. Whenever I want to browse aliases, I can type `git list-aliases` (it's also an alias to `!git config -l | grep alias | cut -c 7- | sort`) and if I want to find aliases related to diffs, I can type `git list-aliases | grep diff`. I also have more descriptive aliases like:

undo-last-commit = reset --hard HEAD^

so I know what this command actually does. Morover, divided my aliases into **separate sections** and marked these sections with comments. The sections are as follows:

*   showing metadata
*   showing urls
*   showing commits, logs & branches
*   ignoring files
*   adding & reviewing changes
*   resetting and reverting changes
*   merging changes
*   branching
*   showing diffs
*   searching files

It allows me to keep my aliases in more organized way. It's useful when our `.gitconfig` file "lives" and we update it during the work day if we need to. Maybe this approach won't be the best way of using Git for everyone, but **it works for me** and allows me to solve my daily tasks easier and faster. You can find complete source of my `.gitconfig` file in my [dotfiles](https://github.com/pwittchen/dotfiles) repository at [https://github.com/pwittchen/dotfiles/blob/master/.gitconfig](https://github.com/pwittchen/dotfiles/blob/master/.gitconfig).

### Further reading

*   [Must Have Git Aliases: Advanced Examples](http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/)
*   [The Ultimate Git Alias Setup](https://gist.github.com/mwhite/6887990)

Happy coding!
