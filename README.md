overview
========

this is source of [wittchen.io](http://wittchen.io) website based on [hexo](https://hexo.io/)

contents
--------
- [installing](#installing)
- [running](#running)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [rest](#rest)

installing
----------

```
make install
```

running
-------

```
make run
```

deployment
----------

there's configured automatic deployment triggered **on push** with GitHub Actions in:

```
.github/workflows/deploy.yml
```

**note**: before deployment, it's recommended to clean and re-generate `public/` dir as follows:

```
make clean
make generate
```

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

to generate new post, type:

```
hexo new post <title>
```

to generate new draft, type:

```
hexo new draft <title>
```

to publish draft, type:

```
hexo publish <title>
```

to create new page, type:

```
hexo new page <title>
```

to discard uncommited changes and files in posts, drafts and pages, type:

```
make discard
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
