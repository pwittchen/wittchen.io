---
title: Working with different Git configs
date: 2017-03-10 19:30:00
tags:
	- git
---

Short introduction
------------------

Sometimes [people need to specify multiple values](http://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig) for single `.gitconfig` file or they want to share just part of the configuration between two machines. There are different approaches for that. I can show you mine.

Different configs for different Operating Systems
-------------------------------------------------

On my private computer, I use Linux. I use Git for my private projects and I use my private e-mail address there. At the same time, I use Git at work on macOS with exactly the same Git configuration, but with a different e-mail address. How to deal with that? In my [.gitconfig](https://github.com/pwittchen/dotfiles/blob/master/.gitconfig) file, I set my private e-mail address, which is used by default. In my [.zshrc](https://github.com/pwittchen/dotfiles/blob/master/.zshrc) file, I created two aliases:

```bash
alias setupGitPersonal="git config --global user.email \"piotr@wittchen.biz.pl\""
alias setupGitForWork="git config --global user.email \"piotr.wittchen@sap.com\""
```

**Hint**: If you want to configure more stuff than just an e-mail, you can do it in the appropriate alias or you can create separate shell scripts for that and place them in `/usr/local/bin/` directory. Then, on Linux, I don't have to do anything and my private e-mail address is used out-of-the-box. On macOS, I do the following trick in `.zshrc` file:

```bash
if [ `uname` = "Darwin" ]; then
  setupGitForWork

  # rest of the macOS config goes here...
fi
```

After that, every time I start terminal on macOS, it automatically sets up my e-mail address to the one I use at work and keeps my `.gitconfig` file updated. **Hint**: If you don't use [zsh](https://en.wikipedia.org/wiki/Z_shell), instead of `.zshrc` file, edit `.bashrc` file.

Different configs for the same OS on two machines
-------------------------------------------------

If you're using different configs on the different machines with the same OS, you can try another trick. Create configuration file - e.g. `.machine_name` in your home directory. Setup one name on one machine and another name on a different machine. Next, include this file in your `.zshrc` or `.bashrc` file, perform appropriate check and load different settings basing on variable name.

```bash
. ~/.machine_name

if [ $machineName = "workMachine" ]; then
  setupGitForWork
else
  setupGitPersonal
fi
```

Contents of the `.machine_name` file are simple:

```
machineName="workMachine"
```

Different configs on the single machine with one OS
---------------------------------------------------

In such case, we are supposed to perform the manual switch. We can use aliases provided above. When we want to have personal settings, we can open terminal and type `setupGitPersonal`. When we want to apply work settings, then we can type `setupGitForWork`.

Summary
-------

As we can see, keeping different configs for different machines or operating systems and changing them depending on our needs is not so hard. I hope these ideas will help you to manage your configs.
