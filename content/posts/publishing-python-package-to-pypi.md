---
title: Publishing Python package to PyPi
tags:
  - python
date: 2018-04-08 11:47:49
---


Introduction
------------

I have my own tiny Python project called [spotify-cli-linux](https://github.com/pwittchen/spotify-cli-linux), which is (surprise!) command line interface for Spotify desktop app on Linux. Python is not my primary programming language and I work more with Java. Nevertheless, I find this language enjoyable and useful in many cases, so I try to learn something new about it from time to time. In the beginning, I've provided instructions how to install my Python script in the system via `curl` and `wget`, which is fine, but it's not recommended and official way to do it. Moreover, people may be afraid of running shell scripts from remote resources on their machines. That's why I decided to upload my project to [PyPi](http://pypi.org/), which is The Python Package Index.

Publishing process
------------------

First, I needed to create [my own account](https://pypi.org/user/pwittchen/) in PyPi, which can be done via official website.

Next, I needed to prepare `setup.py` file in my repository.

```python
from distutils.core import setup

setup(
    name = 'spotify-cli-linux',
    version = '1.0.0',
    description = 'A command-line interface to Spotify on Linux',
    author = 'pwittchen',
    author_email = 'piotr.wittchen@gmail.com',
    url = 'https://github.com/pwittchen/spotify-cli-linux',
    license = 'Apache 2.0',
    packages = ['spotifycli'],
    entry_points = {
       "console_scripts": ['spotifycli = spotifycli.spotifycli:main']
    },
)
```

In this file, I could define a `name`, which can be used for package installation, `url` of GitHub repository or project website, `packages` (in my case I moved my script to separate `spotifycli` directory, which is treated as a package) and `entry_points`, which will be used for invoking the script from the command line. 

In my case, I wanted to achieve such situation:

When people, type: `spotifycli` in the terminal, they'll invoke `main` function from the `spotifycli/spotifycli.py` file and configuration you see above, does the job.

I also created `setup.cfg` file, with the following content:

```
[metadata]
description-file = README.md
```

where I defined `description-file` of my script.

Next, I needed to install `twine`, which is a package used for publishing packages to PyPi. 

```
pip install twine
```

You can find other ways to do that on the web, but most of them are outdated and don't work.

Next, you need to create `~/.pypirc` file in your home directory, with the following content:

```
[distutils]
index-servers =
    pypi
[pypi]
username:yourusername
password:yourpassword
```

You should put inside the same username and password, which you have used for creating account in https://pypi.org website.

Now, we're ready to publish our package!

We can go to our repository and type:

```
python setup.py sdist
```

After that our package ready to deploy will be generated in `dist/` directory.

Next, we can just type:

```
twine upload dist/*
```

and our package will be uploaded to [PyPi](https://pypi.org)!

Then, we can view PyPi page of our project at: https://pypi.org/project/spotify-cli-linux/

and install it with the following command:

```
pip install spotify-cli-linux
```

and we can invoke our script as follows:

```
spotifycli -h
```

That's it! We deployed our script to PyPi! 

Of course, this approach may change depending on your project. E.g. when you are developing a framework or a library, then you probably won't need any setup for running command line tools, but maybe you'll need something additional (I haven't researched this area).

When you'd like to **update** your project, you just need to update version in `setup.py` file, generate `dist/` directory and upload package again. **You can remove uploaded packages from PyPi via the website, but you won't be able to publish package with the version you have already published before (even if it is removed)**. You always need to provide new version. It's good to have it in mind to avoid mess with versioning.

References
----------
- https://zaiste.net/posts/how_to_submit_python_package_to_pypi/
- https://gehrcke.de/2014/02/distributing-a-python-command-line-application/
- https://blog.jetbrains.com/pycharm/2017/05/how-to-publish-your-package-on-pypi/
- http://peterdowns.com/posts/first-time-with-pypi.html
- https://pypi.org/project/twine/
- https://pypi.org/
- https://pypi.python.org/
