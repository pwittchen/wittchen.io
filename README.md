overview
========

this is source of [wittchen.io](http://wittchen.io) website based on [hexo](https://hexo.io/)

[![uptime](https://badgen.net/uptime-robot/month/m783763238-194e22dd4ca99109b8958ff7)](https://stats.uptimerobot.com/ZwxAGU5rxy) [![response](https://badgen.net/uptime-robot/response/m783763238-194e22dd4ca99109b8958ff7)](https://stats.uptimerobot.com/ZwxAGU5rxy) ![last commit](https://img.shields.io/github/last-commit/pwittchen/wittchen.io.svg)

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

there's configured automatic deployment triggered **on push** with GitHub Actions in:

```
.github/workflows/deploy.yml
```

**note**: before deployment, you need to re-generate `public/` dir as follows:

```
make regenerate
```

after that, just commit and push your changes

theme
-----

this blog has customized hexo theme based on [apollo](https://github.com/pinggod/hexo-theme-apollo)

to generate `*.css` file from `*.scss` and rebuild theme, type:

```
make theme
```

after that `gulp` will be in watching mode and if you want to stop it, press <kbd>Ctrl</kbd>+<kbd>C</kbd>

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
