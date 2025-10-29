---
title: New blog, new system, new domain
date: 2018-03-04 12:26:59
---

I've just finished migrating my personal website and blog from [Wordpress](https://wordpress.com) to [Hexo](https://hexo.io/). I've been using Wordpress for more than 5 years and decided to check out something new. Hexo amazed me with its simplicity and ease of use. Probably this tool is more recognized around JavaScript developers, because it's written in that language. I discovered it in the last month.

Features of Hexo
----------------

### Static website generator

For a simple blog with static content I don't really need dynamic website like Wordpress. Content of the articles changes quite rarely. I just generate static content and deploy it to the server.

### Markdown support

I can write articles with Markdown in any editor I want - Sublime or even Vim! In addition, Hexo themes have really nice support for syntax coloring.

### It works off-line

I can write articles off-line and run my blog very easily on localhost while being disconnected from the Internet. I know it could be possible with Wordpress, but it would require a lot of work.

### It doesn't have any database

Right now, all website code and articles (as a markdown files) are stored in a single Git repository. It makes everything easier and it's really neat solution for simple websites and blogs like this one.

### Themes and plugins

Wordpress has them too. Of course, it's important feature, which cannot be avoided in blogging platforms. I'm using customized [apollo theme](https://github.com/pinggod/hexo-theme-apollo) right now. My previous customized Wordpress theme - [gitsta](https://github.com/nehalist/gitsta) -  was quite simple already, but this one is even more minimalistic, what I personally like.

### Hot reload

Thanks to [browsersync](https://browsersync.io/) I can edit my blog, while running it on localhost and see updates without refreshing page manually. It's really convenient and saves time.

### I can use it without leaving terminal

Hexo gives us [CLI tool](https://github.com/hexojs/hexo-cli), which we can use for running blog locally, creating posts, pages and making deployment. I've made a wrapper for a few commands in `Makefile`.

Right now, I can run blog locally with:

```
make run
```

and deploy updated version with:

```
make deploy
```

If you're interested in more technical details, you can view source code and documentation of this website at [github.com/pwittchen/wittchen.io](https://github.com/pwittchen/wittchen.io).

Right now, website doesn't have a few features like comments and search. They're not crucial in my case, but I will hopefully add them in the future.

New domain
----------

I've migrated my website to the new domain: [**wittchen.io**](http://wittchen.io).
It's shorter and simpler.

Old domains: [wittchen.biz.pl](http://wittchen.biz.pl) and [blog.wittchen.biz.pl](http://blog.wittchen.biz.pl) will redirect you to the new address.

New RSS feed address
--------------------

There's also new RSS Feed address, which looks as follows: [wittchen.io/feed.xml](http://wittchen.io/feed.xml).

Summary
-------

I personally like this change and I believe that simplicity is the ultimate sophistication.

I hope you like it too :-).
