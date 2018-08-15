overview
========

this is source of [wittchen.io](http://wittchen.io) website

contents
--------
- [installing](#installing)
- [running](#running)
- [docker](#docker)
- [update](#running)
- [secrets](#secrets)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [rest](#rest)
- [docs](#docs)
- [tools](#tools)

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

if you encounter `EACCESS` errors during resolving dependencies, take a look at [npm docs](https://docs.npmjs.com/getting-started/fixing-npm-permissions)

you can also call `sudo npm install --unsafe-perm` instead of `npm install`

running
-------

```
make run
```

docker
------

**please note**: in order to prepare this docker image correctly, you need to have `npm` and `hexo` installed locally; in this case, generated files will be just copied into the docker image and served via simple HTTP server and Python; it's not the best approach and it can be improved in the future

- to create container, type: `make docker_build`
- to run created container, type: `make docker_run`
- to kill running container, type: `make docker_kill`
- to delete created container, type: `make docker_delete`

update
------

```
git add -p
git commit
git push
```

secrets
-------

configure FTP credentials in `_config.yml` file

have a look at the [official documentation](https://hexo.io/docs/deployment.html#FTPSync)

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

docs
----

- to generate docs, type: `make docs`
- to update docs, type: `make update_docs`
- to clean docs, type: `make clean_docs`
- to run website with docs, type: `make run_docs`

tools
-----

the following tools were used during development of this site:

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
