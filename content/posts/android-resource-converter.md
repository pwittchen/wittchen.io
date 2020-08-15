---
title: Android resource converter
date: 2015-01-17 00:19:00
tags:
- android
- python
- open-source
---

In international projects sometimes there's a need to send resource files to the client in order to have translated strings. Client doesn't have to understand XML notation and editing two or more files at the same time is inconvenient. It's easier to send file which can be edited in MS Excel or Libre Office Calc. I've created Python scripts, which are able to convert Android xml resources with translations to a single `*.csv` file ready to open in software for common users. In addition, there's another script, which can generate xml resource files with translations from `*.csv` file. Generating `*.csv` file from resources is easy: 

```
$ python xml2csv.py directory_with_resources
```

Exemplary output looks as follows:

```
key;strings_english.xml;strings_polish.xml
hello_world;Hello World!;Witaj Świecie!
app_name;My application;Moja aplikacja
```

Generating resources from file with translations is easy as well: 

```
$ python csv2xml.py translations.csv
```

As an output we will get `*.xml` files containing resources for translations in Android application. 

Check out repository here: [https://github.com/pwittchen/android-resource-converter](https://github.com/pwittchen/android-resource-converter)
