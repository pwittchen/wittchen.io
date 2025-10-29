---
title: Automate boring stuff
date: 2017-01-01 11:10:00
tags:
- git
- python
---

Introduction
------------

In my current company all the people who perform creative work (mostly programmers) need to prepare so-called PKUP report. PKUP stands for _Podwyższone Koszty Uzyskania Przychodu_ in the Polish language. It's legal regulation in Poland, which allows paying a lower income tax due to the particular type of work. For the regular employee, it means that he or she will simply get a bit higher salary per month.

How the report looks in practice?
---------------------------------

As a programmer, I simply create software as a source code. Added, removed and modified lines of code in the existing codebase are treated as my creative work. Luckily, we use Git so I can generate `*.diff` files from the Git repositories I'm contributing to. Besides that, I need to prepare document as a `*.docx` file with a short description of my work. My tasks look different every month, but **report actually looks almost the same every month**. Preparing this report is boring and repeatable stuff.

Let's automate it!
------------------

### Generating `*.diff` files from Git repos

I simply created a [shell script](https://github.com/pwittchen/pkup/blob/master/pkup), which goes through predefined project directories and saves `*.diff` files with names the same as project directory with changes performed by me from the 20th day of the last month until now.

### Generating `*.docx` document

Next, I created a [python script](https://github.com/pwittchen/pkup/blob/master/pkup_doc.py), which is parametrized and used by shell script. It uses [python-docx](https://python-docx.readthedocs.io/en/latest/) library for generating `*.docx` report. I've chosen such option, because it's one of the simplest solutions I've found and it's lightweight. Moreover it can be easily used on Unix systems and integrated with shell scripts.

Personalization
---------------

I wanted to make a script available and usable for everyone, so I created [.pkup.conf](https://github.com/pwittchen/pkup/blob/master/.pkup.conf) file, which is responsible for personalization and configuration of the script. I think, it looks pretty straightforward.

```
yDEV_PROJECTS_DIR=$yHYBRIS_SRC
yDEV_PROJECTS_LIST=(backoffice platform-backoffice cockpitng backofficesearch pcm pcmbackoffice cockpit cockpit-core)
yDEV_REPORT_DIR=~/Documents/hybris/pkup/raporty/doc/
yDEV_NAME="Your name"
yDEV_SURNAME="Your surname"
yDEV_ROLE="Software Developer"
yDEV_DEPARTMENT="P&I"
yDEV_MANAGER="Your manager name and surname"
```

Installation and uninstallation
-------------------------------

I also created [installation script](https://github.com/pwittchen/pkup/blob/master/install.sh), which allows to start using the scripts faster. Installation script install dependencies for python script, copies shell script and python script into `/usr/local/bin/` directory and `.pkup.conf` file into home directory. Configuration file needs to be adjusted by the user manually after installtion. Of course, there's another script, which can be used for [uninstallation](https://github.com/pwittchen/pkup/blob/master/uninstall.sh).

Tests
-----

There are python tests for this solution in [pkup\_doc\_test.py](https://github.com/pwittchen/pkup/blob/master/pkup_doc_test.py) file, but they're quite poor right now due to the limited amount of time. They can be a subject of improvements in the future. Note that such scripting solutions rarely have tests because they're small and created ad-hoc. Nevertheless, I wanted to follow the philosophy from [my last blog article](/2016/11/30/lifting-quality-of-a-shell-script/) and create tests for any kind of software I make.

Summary
-------

I've spent some time for preparing this stuff, but it was fun and I think it should save me and hopefully my co-workers some amount of time during creating reports every month. In the future, it can be improved by automatic generation of report messages and sending data to the server.

To sum up, **preparing reports manually is boring**. **Generating reports automatically is exciting**!

Complete solution described in this article with documentation is available on GitHub:
[**https://github.com/pwittchen/pkup**](https://github.com/pwittchen/pkup).
