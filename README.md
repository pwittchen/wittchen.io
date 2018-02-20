blog
====
a source code of my personal website and blog

static pages for the blog are generated with [hexo](https://hexo.io/) framework

running
-------

```
npm install hexo-cli -g
git clone https://github.com/pwittchen/blog.git
cd blog
npm install
hexo server
```

now, access website at: `http://localhost:4000/`

update
------

```
git add -p
git commit
git push
```

protecting secrets
------------------

ignore `config.json` file locally:

```
git update-index --assume-unchanged config.json
```

now, changes in `config.json` file with FTP server credentials won't be commited

deployment
----------

```
npm install ftpsync -g
hexo generate
ftpsync
```

please note, you need to have remote FTP settings configured inside `config.json` file first

I don't use `hexo deploy` command because it forces me to keep secrets in `_config.yml` file and I don't want to do it

theme
-----

this blog has customized hexo theme based on [apollo](https://github.com/pinggod/hexo-theme-apollo)

in order to generate `*.css` file from `*scss` file, go to `themes/custom/` and type:

```
npm install
gulp
```

gulp is in watching mode and when `*.css` file is generated we can manually stop it

of course we need to have `gulp` installed

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
- [node-ftpsync](https://github.com/evanplaice/node-ftpsync)
