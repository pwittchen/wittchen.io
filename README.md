wittchen.io
===========

this is source of [wittchen.io](http://wittchen.io), which is my personal website and blog based on [hugo](https://gohugo.io/)

contents
--------
- [writing](#writing)
- [running](#running)
- [deployment](#deployment)

writing
-------

to create a new post, type

```
hugo new content/posts/my-new-post.md
```

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
