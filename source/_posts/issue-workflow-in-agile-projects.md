---
title: Issue workflow in agile projects
date: 2014-01-15 21:08:00
tags:
    - team
---

In team projects it's important to prepare **issue workflow** and, so-called, **definition of done** in order to be sure, when particular task is actually done. It's often practiced in [**agile**](http://en.wikipedia.org/wiki/Agile_software_development) projects and [**scrum**](http://en.wikipedia.org/wiki/Scrum_(software_development)) process. When we take into consideration IT projects and version control system like [Git](http://git-scm.com/), we can create Git branches with concrete purposes:

*   **master branch** \- latest stable version of the application - for Product Owner and client
*   **development branch** \- latest development version of the application with passed tests and code reviews, but waiting for approval of the Product Owner - for developers
*   **many single branches for each issue (task)** in the project (e.g. creating part of the GUI, coding specific functionality or fixing a bug)

Besides the Version Control System, we also need to have other essential tools for software developement like issue tracker, etc. in order to realize work well. The easiest way to present definition of done (issue workflow) is to prepare a diagram. Exemplary diagram of such process introduced in one of the projects I am working in, is presented below.

![](/images/posts/2014/issue_workflow.png)

Introducing such process in a project increases quality of the software, makes it more stable and whole work becomes systematic and well ordered.
