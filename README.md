blog
====
a source code of [my personal website and blog](http://blog.wittchen.biz.pl) managed by [hexo](https://hexo.io/) framework

visit website on-line at: http://wittchen.biz.pl.

contents
--------
- [installing](#installing)
- [running](#running)
- [update](#running)
- [secrets](#secrets)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [references](#references)

installing
----------

```
git clone https://github.com/pwittchen/blog.git
cd blog/
make install
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
make protect-secrets
```

to expose secrets again, type:

```
make expose-secrets
```

please note: `protect-secrets` rule is invoked during `install` rule

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

to discard uncommited changes on posts, drafts and pages, type:

```
make discard
```

references
----------
- [hexo.io](https://hexo.io/)
- [hexo-theme-apollo](https://github.com/pinggod/hexo-theme-apollo)
- [jade template engine](http://jade-lang.com/)
- [node-ftpsync](https://github.com/evanplaice/node-ftpsync)
- [node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [gulp](https://gulpjs.com/)
- [sass](https://sass-lang.com/)
