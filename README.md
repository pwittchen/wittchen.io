blog
====
a source code of my personal website and blog

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

deployment
----------

```
npm install ftpsync -g
hexo generate
ftpsync
```

please note, you need to have remote FTP settings configured inside `config.json` file first

references
----------
- [hexo.io](https://hexo.io/)
- [hexo-theme-apollo](https://github.com/pinggod/hexo-theme-apollo)
- [node-ftpsync](https://github.com/evanplaice/node-ftpsync)
