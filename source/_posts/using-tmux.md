---
title: Using tmux
date: 2015-09-20 11:04:00
tags:
	- linux
	- tmux
---

> **What is a terminal multiplexer?** It lets you switch easily between several programs in one terminal, detach them (they keep running in the background) and reattach them to a different terminal. And do a lot more.

_\- tmux.github.io_ 


![ss-tmux1](/images/posts/2015/using-tmux/ss-tmux1.png)

Tmux feature, which I find very useful is **tiling terminal window**. We can have several tiles with different terminals within a single terminal window.

How to use tiling?
------------------

First, we need to install tmux:

$ sudo apt-get install tmux

Then, we need to start it:

$ tmux

When we are inside tmux, we can execute its commands. It's good to check [full list of tmux key bindings](http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/tmux.1?query=tmux&sec=1). Default initial key binding for different commands is `Ctrl+B`. When we hold `Ctrl` and then press `B`, we can press next key for specific command. It's tricky and it isn't intuitive at the first time. For example, if we want to **split terminal window vertically**, we need to do the following thing: Start `tmux`, Hold `Ctrl`, press `B` (while holding `Ctrl`), release buttons and press `%` key (equivalent to `Shift+5`). If we want to **split terminal window horizontally**, we need to do the following thing: Start `tmux`, Hold `Ctrl`, press `B` (while holding `Ctrl`), release buttons and press `"` key (equivalent to `Shift+'` \- code for `'` sign is `47` for `xdotool`). We can create any tile configuration we want like in [i3](https://i3wm.org/) windows manager.

![tmux-tiles](/images/posts/2015/using-tmux/tmux-tiles.png)

If we want to **switch between tiles**, we need to use the following key combination: Hold `Ctrl`, press `B` (while holding `Ctrl`), release buttons and press `O` key ("O" letter - not zero).

Creating 4 tiles automatically
------------------------------

Popular terminal windows configuration is 4 tiles (2 columns and 2 rows). We can split windows horizontally or vertically pretty fast with default shortcuts, but creating layout consisting of 4 tiles requires some clicking. I've written a simple script, which generates such layout for us automatically and saves the time. First, we need to install [xdotool](http://www.semicomplete.com/projects/xdotool/):

```
$ sudo apt-get install xdotool
```

Next, we can create file named `tmux-4tiles`, set its `chmod` to 777 and save it in `/usr/local/bin/` directory. File should have the following content:

```bash
#!/bin/bash
\# generates 4 tiles in tmux (requires tmux and xdotool)
xdotool key ctrl+b shift+5 && xdotool key ctrl+b shift+48 && xdotool key ctrl+b o && xdotool key ctrl+b shift+48 ctrl+b o ctrl+b o ctrl+b o && clear
```

When, we are done, we can enter tmux:

```
$ tmux
```

and run the script:

```
$ tmux-4tiles
```

After that, we'll get the following layout: 

![tmux-4tiles](/images/posts/2015/using-tmux/tmux-4tiles.png)

We can automate generating different layouts for our purposes in the same way.

Recap
-----

In my opinion, tmux is very useful tool for people working with terminal who want to have organized windows in an elegant way.

References
----------

*   tmux website: [https://tmux.github.io/](https://tmux.github.io/)
*   tmux source code: [https://github.com/tmux/tmux](https://github.com/tmux/tmux)
*   xdotool website: [http://www.semicomplete.com/projects/xdotool/](http://www.semicomplete.com/projects/xdotool/)
*   xdotool source code: [https://github.com/jordansissel/xdotool](https://github.com/jordansissel/xdotool)
*   cliclick: [http://www.bluem.net/en/mac/cliclick/](http://www.bluem.net/en/mac/cliclick/) \- an alternative for xdotool for Mac OS X users
