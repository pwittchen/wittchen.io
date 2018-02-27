---
title: Geary - neat e-mail client for Linux
date: 2015-08-01 13:41:00
tags:
	- linux
	- ubuntu
---

Overview
--------

I was using web interfaces for e-mail for a long time, but I wanted to give a try a desktop clients for Linux. I was searching for a quite simple solution with almost zero configuration, which I can use for my private and work e-mail accounts. [Geary](https://wiki.gnome.org/Apps/Geary) seems to be quite good choice. It is clean, easy to use and pretty neat e-mail client for Linux. It integrates with Unity on Ubuntu and display system notifications informing about new message. Unfortunately, we need it running in order to see notifications, which is small drawback. Nevertheless it works quite good, so I'm going to give it a try. Install it with the following command:

```
sudo apt-get install geary
```

Pros & cons
-----------

Here is my list of pros and cons of this software.

### Pros

*   almost zero configuration
*   clean & neat interface
*   multiple e-mail accounts
*   integration with the system and notifications informing about new messages
*   recipient suggestions without importing contacts
*   limiting range of downloaded messages - e.g. we can download everything or just messages from last 2 weeks
*   it's open-source: [https://github.com/GNOME/geary](https://github.com/GNOME/geary) \- as we can see on GitHub, it's actively developed
*   it's free

### Cons

*   almost zero configuration, which may be drawback for some people ;-)
*   recipient suggestions does not work with all contacts (I suppose it may be connected with range of downloaded messages)
*   notifications works only when application is running
*   no contact list
*   no calendar available

Interesting fact
----------------

It's written in [Vala](https://wiki.gnome.org/Projects/Vala) language.

Recap
-----

Not all mentioned cons are really bad. As it's just an e-mail client, it doesn't need to have contact list or calendar. It's additional functionality, but there may be some problems while working with systems like MS Exchange or something similar where user need to confirm presence on appointment at work or something like that. To sum up, regardless of a few drawbacks, I can tell that Geary is really nice piece of software, which can be used on daily basis by people who like simple solutions.