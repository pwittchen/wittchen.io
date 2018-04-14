overview
========

this is source of [wittchen.io](http://wittchen.io) website

contents
--------
- [installing](#installing)
- [running](#running)
- [update](#running)
- [secrets](#secrets)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [rest api](#rest-api)
- [used tools](#used-tools)

installing
----------

```
git clone https://github.com/pwittchen/wittchen.io.git
cd wittchen.io/
make install
```

to upgrade project dependencies, type:

```
npm-upgrade
```

running
-------

```
make run
```

update
------

```
git add -p
git commit
git push
```

secrets
-------

configure FTP credentials in `config.json` file

we don't want to commit FTP credentials to any remote repo

to protect them, type:

```
make protect_secrets
```

to expose secrets again, type:

```
make expose_secrets
```

please note: `protect_secrets` rule is invoked during `install` rule

deployment
----------

```
make deploy
```

theme
-----

this blog has customized hexo theme based on [apollo](https://github.com/pinggod/hexo-theme-apollo)

to generate `*.css` file from `*.scss` and rebuild theme, type:

```
make theme
```

after that `gulp` will be in watching mode and if you want to stop it, press `Ctrl+C`

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

rest api
--------

```
GET /api/site.json
GET /api/posts.json
GET /api/posts/{page_number}.json
GET /api/tags.json
GET /api/tags/{tag_name}.json
GET /api/articles/{article_id}.json
GET /api/pages/{page_id}.json
```

used tools
----------
- javascript, css, html
- [make](https://www.gnu.org/software/make/manual/html_node/Introduction.html)
- [hexo](https://hexo.io/)
- [apollo hexo theme](https://github.com/pinggod/hexo-theme-apollo)
- [jade](http://jade-lang.com/)
- [ftpsync](https://github.com/evanplaice/node-ftpsync)
- [browsersync](https://browsersync.io/)
- [node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [gulp](https://gulpjs.com/)
- [sass](https://sass-lang.com/)
- [turndown](https://domchristie.github.io/turndown/)
- [docsify](https://docsify.js.org/)
