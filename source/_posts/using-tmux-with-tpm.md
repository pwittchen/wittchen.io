---
title: Using Tmux plugins with Tpm
date: 2017-08-07 19:31:00
tags:
	- tmux
	- linux
	- tpm
---

Recently, I decided to organize my Unix [dotfiles](https://github.com/pwittchen/dotfiles) in a better way. I had a few custom scripts I used in my Tmux bottom bar. I kept these scripts in `.scripts` directory and during installation or upgrade of my personal configuration, [`install.sh`](https://github.com/pwittchen/dotfiles/blob/master/install.sh) script was copying them from `.scripts` directory to `/usr/local/bin/` directory. I wanted to make this configuration more solid and consistent, so I decided to transform these scripts into tmux plugins managed by [tpm](https://github.com/tmux-plugins/tpm). I was already using a few plugins like:

*   [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar)
*   [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
*   [tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control)
*   [tmux-urlview](https://github.com/tmux-plugins/tmux-urlview)

In my Tmux bottom bar, I display battery level, uptime, CPU, RAM, IP number and song currently played on Spotify. Previously I just used scripts copied to `/usr/local/bin/` and configuration looked like that:

```
set -g status-right "↑ #(showUptime) ⇅ #(showCpuUsage) ☰ #(showRamUsage) ∴ #(showIp) ↯ #{showBatteryLevel} ⧖ #(date '+%a, %b %d, %H:%M') "
```

I created the following plugins to replace these scripts:

*   [tmux-plugin-battery](https://github.com/pwittchen/tmux-plugin-battery)
*   [tmux-plugin-uptime](https://github.com/pwittchen/tmux-plugin-uptime)
*   [tmux-plugin-cpu](https://github.com/pwittchen/tmux-plugin-cpu)
*   [tmux-plugin-ram](https://github.com/pwittchen/tmux-plugin-ram)
*   [tmux-plugin-ip](https://github.com/pwittchen/tmux-plugin-ip)
*   [tmux-plugin-spotify](https://github.com/pwittchen/tmux-plugin-spotify)

In order to use Tmux plugins, we need to install Tmux Plugin Manager:

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

and initialize it at the bottom of our `.tmux.conf` file:

```
run '~/.tmux/plugins/tpm/tpm'
```

After that, it's good to reload shell (`source ~/.zshrc`) and Tmux config (`tmux source-file ~/.tmux.conf`) Next, we can add our plugins to .tmux.conf file:

```
set -g @plugin 'tmux-plugins/tmux-sidebar'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'tmux-plugins/tmux-urlview'
set -g @plugin 'pwittchen/tmux-plugin-battery'
set -g @plugin 'pwittchen/tmux-plugin-uptime'
set -g @plugin 'pwittchen/tmux-plugin-cpu'
set -g @plugin 'pwittchen/tmux-plugin-ram'
set -g @plugin 'pwittchen/tmux-plugin-ip'
set -g @plugin 'pwittchen/tmux-plugin-spotify'
```

When we are in Tmux, we can install plugins by pressing `prefix + I` to install plugins. In my case, `prefix = Ctrl+b`. After that, we can hit `Enter` and we're ready to go! Now, I could update my [`.tmux.conf`](https://github.com/pwittchen/dotfiles/blob/master/.tmux.conf) with the variables defined by my plugins:

```
set -g status-right " 🔉 #{spotify_song} ↑ #{uptime} ⇅ #{cpu} ☰ #{ram} ∴ #{ip} ↯ #{battery_level} ⧖ #(date '+%a, %b %d, %H:%M') "
```

After this operation, I could remove custom scripts from my dotfiles and desired functionality is delivered via plugins. Moreover, anyone can install these plugins via tpm without messing with custom scripts! 

![screenshot from tmux after configuration](/images/posts/2017/using-tmux-with-tpm/tmux-screenshot-07.08.2017.png) 

Right now, my plugins are in kind of messy state and they don't work perfectly across all operating systems (e.g. there are problems on macOS), but they're usable under Linux Ubuntu 16.04 LTS and it's a good beginning for organizing mess created by the custom scripts. That's it! I have plans to publish another article describing how to write your custom Tmux plugin, which can be managed via tpm.
