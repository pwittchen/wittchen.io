blog
====
a source code of my personal website and blog managed by [hexo](https://hexo.io/) framework

contents
--------
- [running](#running)
- [update](#running)
- [secrets](#secrets)
- [deployment](#deployment)
- [theme](#theme)
- [writing](#writing)
- [references](#references)

running
-------

```
git clone https://github.com/pwittchen/blog.git
cd blog/
make install
make run
```

we're using `--unsage-perm` flag in order to preinstall `hexo-cli` and `ftpsync`

now, access website at: `http://localhost:4000/`

update
------

```
git add -p
git commit
git push
```

secrets
-------

ignore `config.json` file locally:

```
make protect-secrets
```

now, changes in `config.json` file with FTP server credentials won't be commited

to expose secrets again, type:

```
make expose-secrets
```

deployment
----------

```
make deploy
```

please note, you need to have remote FTP settings configured inside `config.json` file first

I don't use `hexo deploy` command because it forces me to keep secrets in `_config.yml` file and I don't want to do it

theme
-----

this blog has customized hexo theme based on [apollo](https://github.com/pinggod/hexo-theme-apollo)

in order to generate `*.css` file from `*scss` file, go to `themes/custom/` and type:

```
make theme
```

gulp is in watching mode and when `*.css` file is generated we can manually stop it by typing `Ctrl+C`

this work is required **only when we are changing style of the theme**

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
