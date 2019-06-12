---
title: Poor Man&#39;s Dropbox
tags:
  - linux
  - unix
  - bash
  - cron
  - ftp
date: 2018-08-12 23:10:42
---


## Dropbox abandons Linux users

Recently, I've started receiving a notification from Dropbox desktop app on Linux that they'll stop syncing my files in November. I couldn't understand why. I'm using this service for some time and I find it really useful. Moreover, I want to backup several important files on the web server in case of my disk crashes or I'll need to access them from another computer or mobile device. I googled this issue and found pretty long thread on the [Dropbox Forum](https://www.dropboxforum.com/t5/Syncing-and-uploads/Dropbox-client-warns-me-that-it-ll-stop-syncing-in-Nov-why/td-p/290058). There's also [ongoing discussion on reddit](https://www.reddit.com/r/linux/comments/966xt0/linux_dropbox_client_will_stop_syncing_on_any/).

If you don't want to read all of this stuff, I can make a short summary:
- Dropbox app will support the following file systems: NTFS for Windows, HFS+ or APFS for Mac, and Ext4 for Linux
- Dropbox app will not support encrypted directories even if you're using Ext4 file system on Linux

I had a few options:
- leave my Dropbox directory unencrypted
- switch to another OS
- change service provider to something else
- create my own solution

I'm not going to change my OS now and existing alternatives to Dropbox aren't good enough.

## Preparing Poor Man's Dropbox

I've decided to create Poor Man's Dropbox with `bash`, `lftp` and `cron`. I think it's nice opportunity to learn something new and solve my own problem at the same time. I have my own personal FTP server where I host my website. This server has about 4 GB of disk space. I'm not using all of this space because my website has only text and maybe a few small pics. I also store my photos on the local drive, Google Photos and external physical drive and I'm not going to backup them on the FTP server. I'd like to backup a several dirs with documents, config files, text files and spreadsheets. In such case, mentioned amount of disk space is enough.

In the beginning, I've created a special directory for backup in my local file system: `~/Backup/`.
Next, I've created `backup/` directory on the FTP server.

After that, I've prepared `make_ftp_backup` script:

### Backup script

```bash
#!/usr/bin/env bash

echo "starting backup process"

rm -rf ~/Backup/*

echo "preparing directories to backup"

cp -avr ~/Dokumenty/finance ~/Backup/finance
cp -avr ~/Dokumenty/gym ~/Backup/gym
cp -avr ~/Dokumenty/licenses ~/Backup/licenses
cp -avr ~/Dokumenty/secret ~/Backup/secret
cp -avr ~/Dokumenty/sonatype ~/Backup/sonatype
cp -avr ~/Dokumenty/presentations ~/Backup/presentations

echo "uploading data to the FTP server"

USER=your-user
PASS=your-password
HOST=your-host.com

lftp ftp://$USER:$PASS@$HOST -e "set ftp:ssl-allow no; mirror -R -v --delete-first ~/Backup backup; quit"

date >> ~/Dokumenty/logs/ftp_backup.log

echo "backup process finished"
```

Once I had my script ready, I made it executable: `chmod +x make_ftp_backup`
and placed it in `/usr/local/bin/` directory.

Now, I could test it by typing the following command in the terminal: `make_ftp_backup`.

Script is pretty simple. It deletes old backup files from the local directory, copies updated files to this directory, removes old files on the FTP server and uploads fresh backup files to the server.

### Scheduling backup

Of course, I'm not going to make backups manually, so I used `cron` to automate this job.
I've typed `crontab -e` to define new cron job via `vim` (you can use any editor of your choice).

It looks as follows:

```
# Backup my important files to my FTP server every hour at minute zero
0 * * * * /usr/local/bin/make_ftp_backup
```

Please note, we should not rely on `$PATH` or other environmental variables in `crontab` because most of them are ignored by this service. That's why I provided complete path to the script.

We can list our cron jobs by typing `crontab -l`.

After editing, we could call:

```
sudo service cron reload
```

or (if it didn't work):

```
sudo service cron restart
```

Cron job should work start working without it, but in case of problems, you can invoke that commands.

As you can see in the comments, I'm running my script every hour every day at minute zero.
I've found [very nice video explaining how to use cron](https://www.youtube.com/watch?v=QZJ1drMQz1A). If you're not familiar with it, check this link.
Author of the video created [useful code snippets](https://github.com/CoreyMSchafer/code_snippets/tree/master/Cron-Tasks) explaining crontab syntax.

Reference information for cron jobs placed there looks as follows:

```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * *  command_to_execute
```

It really helps for preparing new cron jobs schedule. You can also visit [crontab.guru](http://crontab.guru/) website to test your cron jobs definitions. It's also good to read more about [troubleshooting crontab](https://serverfault.com/questions/449651/why-is-my-crontab-not-working-and-how-can-i-troubleshoot-it) in case of encountering any problems.

### Copying data from the server to the local directory

Solution above just uploads local files to the remote server. Sometimes we may want to add some data from another computer or mobile device and access them later on the local computer. We shouldn't place this data to the `backup` directory because it may be overriden by the backup script. To solve this problem, we can create `input` directory on the remote server and `input` directory in the local file system. After that, we can create `get_ftp_input` script, which will copy remote directory to local file system.

```bash
#!/usr/bin/env bash

USER=your-user
PASS=your-password
HOST=your-host.com

echo "downloading input from the server"

lftp ftp://$USER:$PASS@$HOST -e "set ftp:ssl-allow no; mirror -v input ~/Dokumenty/input; quit"

date >> ~/Dokumenty/logs/ftp_input.log

echo "download complete"
```

It's not real synchronization like in the Dropbox, but at least we have simple way add new files to the local computer from the different device with Internet access and FTP client. We can add this script to the crontab too, if we want to.

### Accessing files on the go

On my Android phone, I'm using [Solid Explorer app](https://play.google.com/store/apps/details?id=pl.solidexplorer2) for browsing files and directories. It's really good app and it has FTP client built-in, so I can access my backup folder from my mobile phone if I need to.

## Summary

I know this solution is far from perfect (I call it poor myself) and it doesn't handle two way synchronization, but at least I have full control over it and nobody tells me what file system or operating system I have to use or what I need to leave encrypted or unencrypted. It's clean, simple and fine for me now. Maybe I'll enhance this solution some day. E.g. I can add a new script performing backup whenever I change any file in defined list of directories. In order to do that, I'll need a file watcher running as a system service in the background. The biggest room is the room for improvement.
