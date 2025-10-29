---
title: Browsing directories with Vim
date: 2017-04-02 19:04:00
tags:
- linux
---

I'm still learning Vim every day. At first, it looks quite hard and most of the people want to learn how to quit it and never use again. Nevertheless, when you learn some basics, you can be really productive. This editor has much more cool functionalities than just `:q` shortcut ;-). Recently I discovered, you can use Vim not only for editing files but you can use it for browsing directories as well! Just go to any directory you want in terminal and type:

```
vi .
```

Then you have very nice file browser: ![](/posts/2017/browsing-dirs-with-vim/vim-browsing-dirs.png) You can use most of the regular Vim commands like `/yourkeyword` for searching. ![](/posts/2017/browsing-dirs-with-vim/vim-searching-dirs.png) You can also navigate up and down with `j` and `k` as inside the files. To enter directory, just press `Enter` You also have other features like `-` key for going up, `s` for sorting, `R` for renaming and `D` for deleting. To quit this browser, just type `:q` (the same shortcut as in the editor). I know, this file browsing functionality is not perfect, but it's much better than regular navigation and directory browsing in the console with `cd`, `ls` and searching with `grep`. In some cases it may be a perfect choice!
