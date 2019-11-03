---
title: GitHub Actions in action!
tags:
    - ci
    - git
    - github
    - automation
---

Recently GitHub introduced really interesting feature to their service called [Actions](https://github.com/features/actions). Actions can be used for automating various tasks related to the repositories like CI, CD, testing, deployment and whatnot. The general concept is as follows: We can create so called action, which can be based on JavaScript language or Docker container. We can also use existing actions in the [Marketplace](https://github.com/marketplace?type=actions). Next, we can create workflow in the `yml` file, where we define our workflow. Workflow can consist of many steps using different actions. We can also define multiple jobs, where one depends on another. Workflows can be triggered in many ways. E.g. by push, pull request, creating issue, publishing release, scheduled event or external event.

E.g. we can define scheduled event, which will trigger workflow every hour as follows:

```
on:
  schedule:
    - cron:  '0 * * * *'
```

It has the same syntax like cron.

We can do many things with workflows and actions like deploying websites, artifacts with libraries, run tests on multiple environments, execute shell scripts on external servers and more. Have a look at the [official Github documenation](https://help.github.com/en/github/automating-your-workflow-with-github-actions) and [Marketplace](https://github.com/marketplace?type=actions) to see what people are creating.

I wanted to try out these actions and workflows, so I automated the deployment process of my website (this one, which you're visiting right now). Its code is open source and you can see it at https://github.com/pwittchen/wittchen.io. I host my website on the external web server. I can access it via FTP and SSH. Website is based in [hexo](http://hexo.io) framework for static website generation. Before deployment I regenerate contents of the `public/` directory with command:

```
make regenerate
```

Then, I can commit and push my changes. My action is triggered whenever I push a change to the `public/` directory on the repository on the `master` branch. Once it's done, workflows checks out my repository and starts copying files the the FTP server in the defined directory. GitHub allows us to keep the secrects like usernames and passwords inside the repository configuration. we can access it via settings on the website. Once they're created, they cannot be viewed or edited. We can just delete them (and create again if we want to). Our workflow file has to be located in the `.github/workflows/` directory. We can have more than one workflow.

You can see my `deploy.yml` workflow below:

```yml
name: Publish Website
on:
  push:
    branches:
      - master
    paths:
      - 'public/*'
jobs:
  FTP-Deploy-Action:
    name: FTP-Deploy-Action
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: FTP-Deploy-Action
      uses: SamKirkland/FTP-Deploy-Action@2.0.0
      env:
        FTP_SERVER: ${{ secrets.FTP_SERVER }}
        FTP_USERNAME: ${{ secrets.FTP_USERNAME }}
        FTP_PASSWORD: ${{ secrets.FTP_PASSWORD }}
        REMOTE_DIR: ${{ secrets.FTP_REMOTE_DIR }}
        LOCAL_DIR : "public"
        ARGS: --delete --transfer-all
```

Previously I was using `deploy.sh` bash script, which looked like that:

```bash
#!/usr/bin/env bash
source .ftpconfig
lftp ftp://$USER:$PASS@$HOST -e "set ftp:ssl-allow no; rm domains/$HOST/public_html/css/apollo.css; mirror -R -v --only-newer public domains/$HOST/public_html; quit"
```

I had to be careful to avoid commiting `.ftpconfig` file and exclude it from commits like that:

```
git update-index --assume-unchanged .ftpconfig
```

In my workflow, I used `FTP-Deploy-Action`, which uses `lftp` program for the deployment, so it's the same program I used for deployment of my website before, but now it's executed on the GitHub infrastructure - not my computer. Thanks to that, I have automated website deployment process and whenever I update my website and regenrate it, it's uploaded automatically to my server via FTP.

On the [GitHub website](https://github.com/features/actions), we can read that depending on our subscription status, we can have several amounts of free minutes for executing actions and after crossing given thershold, we will be charged per minute. As far I as see amount of minutes is enough for personal usage and prices are reasonable.

If you're using GitHub, then Actions are definitely worth considering for automation, because they give you endless opportunities for automating your work and CI/CD pipelines with huge flexibility and stability thanks to Docker containers. In the future probably I'll play more with it and maybe automate the last stage of the release process of my Java and Kotlin libraries with that feature.

## References
- https://help.github.com/en/github/automating-your-workflow-with-github-actions
- https://help.github.com/en/github/automating-your-workflow-with-github-actions/configuring-a-workflow
- https://help.github.com/en/github/automating-your-workflow-with-github-actions/building-actions
- https://help.github.com/en/github/automating-your-workflow-with-github-actions/setting-up-continuous-integration-on-github
- https://github.com/marketplace?type=actions
- https://github.com/maddox/actions
