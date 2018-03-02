blog
====

this is source of [blog.wittchen.biz.pl](http://blog.wittchen.biz.pl) website

contents
--------
- [installing](#installing)
- [running](#running)
- [update](#running)
- [secrets](#secrets)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [docs](#docs)
- [references](#references)

installing
----------

```
git clone https://github.com/pwittchen/blog.git
cd blog/
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

docs
----

to generate docs, type:

```
make docs
```

to update docs, type:

```
make update_docs
```

to run server with docs, type:

```
make run_docs
```

to clean docs, type:

```
make clean_docs
```

references
----------
- [hexo](https://hexo.io/)
- [apollo](https://github.com/pinggod/hexo-theme-apollo)
- [jade](http://jade-lang.com/)
- [ftpsync](https://github.com/evanplaice/node-ftpsync)
- [browsersync](https://browsersync.io/)
- [node](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [gulp](https://gulpjs.com/)
- [sass](https://sass-lang.com/)
- [turndown](https://domchristie.github.io/turndown/)
- [docsify](https://docsify.js.org/)
