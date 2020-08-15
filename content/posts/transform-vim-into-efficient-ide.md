---
title: Transform Vim into efficient IDE
date: 2017-04-16 19:32:00
tags:
- linux
---

Introduction
------------

Some time ago, I decided to learn Vim. A lot of people are afraid of this editor and they usually don't want to know anything about it or just learn how to quit it. In my opinion, it's good to learn it because after mastering the basics, we can work very efficiently. After some time of usage, we may even replace editors like Atom or Sublime Text with Vim. Moreover, Vim is default editor for a few Unix tools like Git, so it's good to know how to use it when we accidentally open it. In addition, sometimes we have an access only to the terminal (e.g. via ssh) and we need to perform a task on the remote server, so we don't have any possibility to use editors with GUI. In such cases, Vim is a perfect solution. Last, but not least - if you want to be a **real** _h4x0r_, you should know it (or at least its basics) ;-).

Learning basics
---------------

Vim is not an intuitive text editor like many others. **It needs to be learned. Just like a programming language.** There are a few basic things, which you need to know to use Vim:

*   Opening editor: just type `vi` or `vi filename` to open file.
*   Basic modes: interactive (enter it with `i` key), visual (enter it via `v` key), read only (default - go back to this mode via `Esc` key). You can also use `Esc` key to cancel any kind of operation.
*   Navigation: to navigate in the document, we need to be in read only mode and instead of arrow keys, we use `h` (left), `j` (down), `k` (up), `l` (right). Note that these keys are close to each other in a row on the keyboard. Such setup may be even more comfortable than arrow keys.
*   Saving changes in file: to save file, type `:w`.
*   Quiting: To quit vim, type `:q`.
*   Quiting without saving: `:q!`.
*   Quiting with saving: `:wq`.

In my opinion, **the best way to learn Vim basics** is to use `vimtutor` application. Just open terminal and type `vimtutor`. It will open a text file with Vim tutorial inside Vim and you can follow instructions in this file to learn how to use this editor. You can also use other resources like:

*   [http://www.openvim.com/](http://www.openvim.com/) (interactive on-line tutorial)
*   [https://linuxconfig.org/vim-tutorial](https://linuxconfig.org/vim-tutorial)
*   [http://www.nuxified.org/vi\_survival\_guide/](http://www.nuxified.org/vi_survival_guide/)
*   [https://github.com/mhinz/vim-galore](https://github.com/mhinz/vim-galore)
*   and many others

Efficient navigation and file editing
-------------------------------------

Thanks to various key bindings, Vim allows you to navigate & edit files very quickly. E.g. you can jump between words with `w` key. You can also combine different key bindings. E.g. `d` is for deleting text. When you combine `d` & `w` (`dw`) you can delete single word. This "Vim language" can be a subject of the separate article, so I won't explain it in details in this article. It's good to go through tutorials and learn this editor as you use it.

Personal configuration
----------------------

You can customize Vim and keep its configuration in `.vimrc` file located in your home directory. Below, you can find my configuration with comments. I copied it from somewhere and modified a little bit.

```
set clipboard=unnamed       "Enable clipboard
filetype plugin indent on   "Enable indent plugin
syntax enable               "Enable syntax coloring
syntax on                   "Turn syntax coloring on
:color desert               "Set desert syntax coloring
set nocompatible            "Allow Vim-only settings even if they break vi keybindings.
:filetype on                "Enable filetype detection
set incsearch               "Find as you type
set ignorecase              "Ignore case in search
set scrolloff=5             "Number of lines to keep above/below cursor
set smartcase               "Only ignore case when all letters are lowercase
set number                  "Show line numbers
set wildmode=longest,list   "Complete longest string, then list alternatives
set fileformats=unix        "Use Unix line endings
set smartindent             "Smart autoindenting on new line
set smarttab                "Respect space/tab settings
set history=300             "Number of commands to remember
set backspace=2             "Use standard backspace behavior
set hlsearch                "Highlight matches in search
set ruler                   "Show line and column number
set formatoptions=1         "Don't wrap text after a one-letter word
set linebreak               "Break lines when appropriate
set autoindent              "Auto indent based on previous line

                            "Prepare tab/space indent settings
set tabstop=4               "Set Tab width to 4
set shiftwidth=4            "Indents will have width of 4
set softtabstop=4           "Set the number of columns for tab
set expandtab               "Expand tabs to spaces

execute pathogen#infect()
```

Plugin manager
--------------

We can enhance Vim by adding additional plugins. There are a few plugin managers for Vim. I personally like [pathogen](https://github.com/tpope/vim-pathogen) because it's quite easy to install and easy to use.

Useful plugins
--------------

I use 3 plugins right now:

*   [nerdtree](https://github.com/scrooloose/nerdtree) (adds sidebar with list of files and directories)
*   [tagbar](https://github.com/majutsushi/tagbar) (adds overview of the currently edited file with navigation like list of methods, attributes etc. and works for different programming languages)
*   [ctrlp](https://github.com/kien/ctrlp.vim) (adds very fast file search)

Summary
-------

Below, you can see my setup with nerdtree & tagbar opened. As you can see, Vim can be very powerful and customizable editor & can make our work more efficient. It has a lot of features. Nevertheless it's not easy to learn and we have to spend some time to learn how to use it. I think, the best approach is to learn the basics, start using it and then learn rest of the stuff we need during the time. Of course, it has drawbacks like lack of default debugger, steep learning curve and so on. On the other hand, I still think it's worth to learn it. There are also languages with command line debuggers, so you can combine Vim with Tmux and have everything you need on one screen. I hope you'll find my tips helpful and you'll be encouraged to give this editor a try. It's definitely not a tool for newbies, but I suppose you are not one of them ;-). ![](/posts/2017/transform-vim-into-efficient-ide/vim-config-01.png)
