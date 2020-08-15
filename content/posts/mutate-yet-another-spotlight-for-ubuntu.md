---
title: Mutate - yet another Spotlight for Ubuntu
date: 2015-04-06 12:26:00
tags:
- ubuntu
- linux
---

Overview
--------

Some time ago, I published post about Synapse indicator, which is an alternative to MAC's Spotlight for Ubuntu. Recently, I've found another software, which is in my opinion even better than Synapse. It's called [Mutate](https://github.com/qdore/Mutate). I like it, because it works quite smooth, looks simple and clean. In addition, it's open-source. 

![mutate-1](/posts/2015/mutate/mutate-1.jpg)

Installation
------------

We can install it with the following commands:

```
sudo add-apt-repository ppa:mutate/ppa
sudo apt-get update
sudo apt-get install mutate
```

Configuration
-------------

After installation, we can run Mutate from Ubuntu dashboard or via default hot-key `CTRL+D` and type `preference`. 

![mutate-7](/posts/2015/mutate/mutate-7.jpg)

After that, we can configure default hot-key for muate. E.g. `CTRL+Space` as on the screen below or another hot-key, which we prefer. 

![mutate-8](/posts/2015/mutate/mutate-8.jpg)

This configuration is saved in `~/.config/Mutate/config.ini` file and we can edit it manually. Manual editing is, in my opinion, more convenient, because GUI of Mutate preferences seems to be buggy and `config.ini` file is quite readable. After editing of the file, changes are available in Mutate immediately without any reboot. We can also add more shortcuts and create our own python or shell scripts in `~/.config/Mutate/scripts/` directory or create references to scripts in other places.

References
----------

*   [Article about Mutate at noobslab.com](http://www.noobslab.com/2014/12/mutate-is-alternative-to-macs-new.html)
*   [Source code of Mutate](https://github.com/qdore/Mutate)
