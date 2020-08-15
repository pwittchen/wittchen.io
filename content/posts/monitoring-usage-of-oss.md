---
title: Monitoring usage of open-source projects
date: 2017-05-02 19:51:00
tags:
- open-source
---

While developing open-source projects it's important to monitor usage of them. Having that information we know on which projects we should concentrate the most and which are becoming more popular. In this short article, I'll present you two tools, which can help you with that.

GitHub
------

On GitHub, each project has "Traffic" tab. After clicking on it, we can see how many visitors and unique visitors we have, we can also check how many project clones and unique clones were performed (including CI servers). Moreover, we can see referring sites for our projects. It's useful information because we can check how people gather information about our project. 

![](/posts/2017/monitoring-usage-of-oss/github-stats.png)

Sonatype
--------

GitHub stats can be used for any type of project for any language. When we're developing Java or JVM library and we publish it on SonaType, we can also use [oss.sonatype.org](http://oss.sonatype.org) website for monitoring usage of our libraries. It provides us quite interesting information, which actually tells us if anyone is using our library. 

![](/posts/2017/monitoring-usage-of-oss/sonatype-stats.png)

In the "Central Statistics" section, we can select `GroupId` and also `ArtifactId`. We can see accumulated information about downloads of all our projects in time and check, which project is the most popular. We can also view downloads from unique IPs. What I found interesting here is the fact that one of my projects called [prefser](https://github.com/pwittchen/prefser) is quite popular and people really started using it in their projects! Approximately 47% of downloads of all my projects are downloads of that single library. Nevertheless, the last release of this library (v. 2.0.6) was almost one year ago. It encouraged me to put more effort into this project and make it better. I actually started working on it again and planned new releases. Trust of many people is a huge motivation factor & honor for me. Do you know any more methods of measuring usage of your projects? Maybe for different technologies than Java? Share your experiences in comments :).
