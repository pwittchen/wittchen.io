wittchen.io
===========

this is source of [wittchen.io](http://wittchen.io), which is my personal website and blog based on [hugo](https://gohugo.io/)

[![uptime](https://badgen.net/uptime-robot/month/m783763238-194e22dd4ca99109b8958ff7)](https://stats.uptimerobot.com/ZwxAGU5rxy) ![last commit](https://badgen.net/github/last-commit/pwittchen/wittchen.io) ![Publish Website](https://github.com/pwittchen/wittchen.io/workflows/Publish%20Website/badge.svg)

contents
--------
- [running](#running)
- [deployment](#deployment)
- [writing](#writing)

running
-------

```
hugo server -D
```

deployment
----------

just update content and run command:

```
hugo -D
```

then commit and push your changes

deployment will be triggered automatically with github actions

writing
-------

to create a new post, type

```
hugo new content/posts/my-new-post.md
```
