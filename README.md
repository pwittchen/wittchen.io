wittchen.io
===========

this is source of [wittchen.io](http://wittchen.io), which is my personal website and blog based on [hexo](https://hexo.io/)

[![uptime](https://badgen.net/uptime-robot/month/m783763238-194e22dd4ca99109b8958ff7)](https://stats.uptimerobot.com/ZwxAGU5rxy) ![last commit](https://badgen.net/github/last-commit/pwittchen/wittchen.io) ![Publish Website](https://github.com/pwittchen/wittchen.io/workflows/Publish%20Website/badge.svg)

contents
--------
- [running](#running)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [rest](#rest)

running
-------

```
installing dependencies:                      make install
running server locally:                       make run
running server locally with posts and drafts: make rundrafts
```
deployment
----------

to deploy website, type:

```
make deploy
```

to learn details about deployment, see the source of the following files:

```
Makefile
.github/workflows/deploy.yml
```

theme
-----

this blog has customized hexo theme based on [apollo](https://github.com/pinggod/hexo-theme-apollo) and to generate/regenerate theme, type:

```
make theme
```

writing
-------

create and manage content with the following commands:

```
create new post:                        hexo new post <title>
create new draft:                       hexo new draft <title>
publish draft:                          hexo publish <title>
create new page:                        hexo new page <title>
discard uncommitted changes and files:  make discard
```

rest
----

you can use the following REST API:

```
GET /api/site.json
GET /api/posts.json
GET /api/posts/{page_number}.json
GET /api/tags.json
GET /api/tags/{tag_name}.json
GET /api/articles/{article_id}.json
GET /api/pages/{page_id}.json
```
