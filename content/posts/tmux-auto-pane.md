---
title: Automate tile layouts creation in tmux with tmux-auto-pane
date: 2017-04-08 13:05:00
tags:
- linux
---

I just released [tmux-auto-pane](https://github.com/pwittchen/tmux-auto-pane). It's a tiny shell script for creating pre-defined tile layouts in [Tmux](https://tmux.github.io/) on Linux with [xdotool](http://www.semicomplete.com/projects/xdotool). In our workflow, we often have some pre-defined pane configurations in a terminal. The project called `tmux-auto-pane` helps to automate that process. It can save us some time and make us a bit more productive. We can call `tmux-auto-pane` with one of the following parameters:

```
--help | -h   showing help
--1l1r        one left, one right
--1l2r        one left, two right
--2l1r        two left, one right
--1u1d        one up, one down
--1u2d        on up, two down
--2u1d        two up, one down
--4tiles      4 tiles, 1 in each corner
```

for example `tmux-auto-pane --4tiles` will generate such layout:

```
 ____ ____
|    |    |
|____|____|
|    |    |
|____|____|
```

we can also have the following layouts:

```
    1l1r         1l2r         2l1r         1u1d        1u2d         2u1d
 ____ ____    ____ ____    ____ ____    _________    _________    ____ ____
|    |    |  |    |    |  |    |    |  |         |  |         |  |    |    |
|    |    |  |    |____|  |____|    |  |_________|  |____ ____|  |____|____|
|    |    |  |    |    |  |    |    |  |         |  |    |    |  |         |
|____|____|  |____|____|  |____|____|  |_________|  |____|____|  |_________|
```

Script can be installed via `wget`:

```
sh -c "$(wget https://raw.githubusercontent.com/pwittchen/tmux-auto-pane/master/install.sh -O -)"
```

or via `curl`:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pwittchen/tmux-auto-pane/master/install.sh)"
```

Due to the fact, that `tmux-auto-pane` uses `xdotool` under the hood, unfortunately **it works only with Linux** right now. It can be improved in the future to work with macOS as well. Source of the project can be found at [https://github.com/pwittchen/tmux-auto-pane](https://github.com/pwittchen/tmux-auto-pane). This project could be extended to start specific applications in each pane. Maybe, I'll improve it in the future, so users could parametrize their custom applications. I hope Tmux & Linux users will find it useful :).
