---
title: One year of using Macbook Pro at work as a software developer
date: 2017-01-29 13:48:00
tags:
	- macbook
	- apple
---

Introduction
------------

For most of the time, I was MS Windows user. I was using this OS since Windows 95 up to Windows 10 ( the last version really occasionally). About ~3 years ago, I switched to Linux (Ubuntu) on my private computer. I used it before on virtual machine or sometimes in dual boot with Windows. About one year ago, I changed my job and decided to switch to Macbook Pro at work. I also had an option of choosing a laptop with MS Windows, but I was already a bit familiar with Unix, so I decided to learn something new and try Apple stuff. It had OS X El Capitan installed and it was later upgraded to macOS Sierra. I decided to collect my thoughts related to using Macbook in this article. Below you can see a photo of my current work-station in the office. [![](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/workstation-at-sap-hybris-office.jpg)](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/workstation-at-sap-hybris-office.jpg) In the beginning, it seemed that it's something different than systems I already used, but it was quite similar to Linux. There's Unix shell, [HUD](https://en.wikipedia.org/wiki/Head-up_display) like in the Unity on Ubuntu. I don't use Unity on Linux anymore, but I'm familiar with that concept. Settings window also looks similar to Unity or Gnome. Macbook is connected to one monitor via HDMI and to another one via mini-display port. The keyboard is connected via USB and magic mouse is connected wirelessly via Bluetooth. It's worth mentioning that Macbook doesn't have RJ45 port, so you need an adapter if you want to be connected to the network via cable. There's adapter from mini-display port to RJ45 and from USB to RJ45. You can choose one of them. If you need any specific device setup, better check hardware specification, available adapters and their cost.

Configuration as a code
-----------------------

After some time of using Linux, I discovered that I can keep my personal configuration as a code. My config is open-source and you can see it in my [dotfiles](https://github.com/pwittchen/dotfiles) repo. This is very useful when you want to restore your configuration if you're installing a system from the scratch or you accidentally lost your data and want to have a backup. Moreover, when you are using two Unix machines like me right now, you can share your configuration between them. On macOS I can use the same stuff like on Linux. E.g. Zsh, Tmux, Vim, etc. Nevertheless, there are differences between Linux and macOS. That's why in my [.zshrc](https://github.com/pwittchen/dotfiles/blob/master/.zshrc) file, I have [a separate section for Linux](https://github.com/pwittchen/dotfiles/blob/master/.zshrc#L91) and [the separate section for macOS](https://github.com/pwittchen/dotfiles/blob/master/.zshrc#L161). Moreover, sometimes scripts also need to be customized separately for different systems. Using macOS helped me to make my config more robust and now I can use it easily both on macOS and Linux without huge problems. [![](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/macos_screenshot-1024x640.png)](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/macos_screenshot.png)

Apps
----

Of course, I needed to find apps, which will be useful for me during daily work and usage of the system. Below you can see what I find useful. **Basics**

*   [Homebrew](http://brew.sh/) \- Missing package manager for macOS; it's obvious thing for Linux systems, but on macOS you need additional software for that.
*   [iTerm2](https://www.iterm2.com/) \- Terminal emulator with possibility of searching, creating tabs, creating panes horizontally and vertically. It's better than default Terminal app.
*   [Spectacle](https://www.spectacleapp.com/) \- An app for resizing and moving windows. On macOS for me it's very annoying that when you resize the window to the full-screen, it hides top menu (HUD) and dock and jumps into separate workspace. We can solve that problem by installing spectacle and with appropriate shortcuts you can resize window without hiding anything. It has also a few additional features regarding windows resizing. Moreover, it's good to remember to disable shortcuts, which conflicts with iTerm2 shortcuts for splitting the panes if you are using them like me.

**Development Tools** Here are my basics apps I use for development. I also use terminal tools, but I mentioned them earlier in this article. All of them works pretty the same as on other platforms. Docker for Mac was improved so we can use Docker as easy as on Linux right now.

*   [IntelliJ IDEA](https://www.jetbrains.com/idea/)
*   [Atom](https://atom.io/)
*   [Docker for Mac](https://docs.docker.com/docker-for-mac/)

**Messengers** We also have basic messengers. It's no difference comparing the to other systems. Maybe Skype is simpler than Windows version. Linux version of Skype is also quite simple because they probably stopped developing it. It's strange because it's good and bad at the same time.

*   [Skype](https://www.skype.com/en/)
*   [Slack](https://slack.com/)
*   [Hipchat](https://www.hipchat.com/)
*   [Mattermost](https://about.mattermost.com/) \- Interesting tool I use at daily work. It's an open-source alternative for Slack.

**Menu indicators** I like the concept of menu indicators in HUD. It's similar to Gnome Classic and Gnome 3 desktop environment for Linux.

*   Caffeine. It's the same as on Linux. It's an indicator, which prevents screen lock.
*   [Menu meters](https://www.ragingmenace.com/software/menumeters/). It's similar to Linux indicator. You can measure CPU, Memory and network usage.
*   [Degrees](https://itunes.apple.com/pl/app/degrees-weather/id430173763?mt=12). It's an indicator for checking weather and temperature in your city.

**Additional apps** There are also a few additional apps I use...

*   Commander One - "Total Commander"-like app for macOS. Total Commander is one of the apps I really miss on non-MS systems, because its replacements are never as good as the original app.
*   Default Mail and Calendar app
*   MS Outlook - the newest version looks much better after update, nevertheless notifications are still not consistent with macOS UI (at least they look a bit better) and closing app means killing it like on Windows, but it's uncommon behavior for macOS.
*   MS Office apps
*   Evernote
*   Simplenote
*   Wunderlist
*   Spotify

[![](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/macbook-and-magic-mouse.jpeg)](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/macbook-and-magic-mouse.jpeg)

What's different?
-----------------

There are things, which are slightly different on macOS and I needed to get used to them during the time.

*   **Apps are not closed until you explicitly close them**. Apps behaves a bit like on Android. They go to the background and you can wake them up. If you want to kill the app explicitly you have to use Command+Q shortcut or choose "Quit" option from the context menu.
*   **Keyboard and shortcuts**. The keyboard is different. We have additional Command key, which replaces Windows Key and a few additional keys. System shortcuts are also different. There's no "Print Screen" key, but there's a shortcut for that. Moreover, IntelliJ shortcuts are also different than on Windows and Linux, but I learned them during the time without any shortcuts re-mapping like some people do. In my opinion, it's a better approach than re-mapping, because we have different keyboard and opportunity to train our brain a little bit.
*   **Workspaces**. This functionality became a standard in the latest versions of OS X and Windows. Nevertheless, it was available on Linux Desktop Environments long time ago.
*   **Dividing screen**. This is similar to Windows and Linux, but with a few differences. When we divide the screen and share it between two windows, this view goes to a separate workspace without HUD and Dock. I don't like it. Additionally, we can grab a dividing line and adjust space of one window or another by dragging like in Tmux. This is really cool feature, which is not available on Windows and Linux DEs as far as I know.
*   **Head Up Display and Dock**. As I mentioned earlier in this article HUD is a concept similar to the Unity DE from Ubuntu, but I suppose Apple was first with that idea. I'm not a fan of Dock. Its functionality is more or less the same as a bottom bar from Windows, but with a bit different UI/UX. It's hard to say, which one is better.
*   **Hiding and showing hidden files**. I haven't found an option of showing hidden files like I can do on Windows or Linux. I had to do a trick and create an [alias in my .zshrc file](https://github.com/pwittchen/dotfiles/blob/master/.zshrc#L201) to show and hide hidden files. Commander One app is able to show and hide hidden files via GUI, but it's third party app.
*   **Spotlight**. The Spotlight is a useful feature, which you can use for launching apps. You can also use it for other things like searching mail, calendar, places and so on, but I don't really use these additional things.
*   **Siri**. Siri is an assistant with voice recognition. It was available on iPhone earlier. In macOS they brought it to the desktop. It's cool, you can ask it about weather or launch an app with voice command, but I don't really use it in daily work.

Observations
------------

Here are a few of my observations I made while using Mac.

*   **It doesn't work exactly the same as Linux, but it's in the same Unix family**. We can use nice terminal, Zsh, Vim, Tmux and stuff similar to Linux, but sometimes we need to adjust things to Mac and not all commands, which are valid for Linux are also valid for Mac.
*   **It's more stable than Linux**. I don't remember if I encountered any crashes or problems related to system itself on Mac. Maybe system hanged once or twice in a year.
*   **It's less customizable than Linux**. On Mac you cannot change the desktop environment and do a lot of customizations like on Linux. Luckily UI of macOS is nice, although Gnome UI is, in my opinion, a bit more minimalistic, what I actually like.
*   **It's simpler than MS Windows**. From my perspective macOS is simpler than MS Windows. In MS Windows they tend to change everything in the successive releases and UI gets more complicated. In macOS they try to keep everything simple and consistent with their standards.
*   **Software vendors care about macOS users**. Every popular app has an official macOS version (e.g. Evernote, Wunderlist, Photoshop, etc.). You cannot say that about Linux.
*   **Almost every dummy app is not free**. I'm not against buying software and I use licensed commercial software. Nevertheless, in App Store almost every dummy app for doing one simple thing is paid, what can be annoying especially if you are using Mac at work and don't want to connect it with your personal payment cards.

Design & Hardware
-----------------

We can discuss software issues, but there are things, which Apple makes the best and leaves the competition behind. These things are **design & hardware**. Macbook's touchpad is the best touchpad I've ever used. It's smooth easy to use and is integrated with the system in a very convenient way. Page scrolling is really smooth and natural. There are gestures for switching workspaces, scattering windows, zooming, etc. Retina display screen is very clear, has high resolution and it's much better than displays of the other laptops. Speakers are incredibly clear and music sounds better than in regular laptops. A lot of people complain about the necessity of using adapters. I haven't really had such problems. The only adapter I needed was USB to RJ45 adapter for a wired network. I could connect one external screen via mini-display port and another one via HDMI port. I think an issue with adapters can be serious for people who use a lot of specific external devices. The battery in the Macbook works fine, but it's getting worse as long as you're using a laptop. If you start energy consuming services and apps it can be drained in less than 8 hours now. I think it was better in the beginning of the usage (one year ago). The thing, which I really like in Macbook is the **design**. It's very clean & simple. It's also made from high-quality materials and looks really well. People who care about aesthetics will appreciate that. [![](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/pexels-photo-48727-1024x576.jpeg)](/images/posts/2017/one-year-of-using-macbook-pro-as-dev/pexels-photo-48727.jpeg)

Summary
-------

To sum up, I can tell that Macbook is really nice & expensive piece of hardware. I could recommend such device to people, who can afford and want to spend more money than usual on their computer. I would also recommend this device to people who travel a lot and need to work with laptop screen and touchpad because Apple made them better than the competition. I can also recommend this device to people who don't want to spend too much time on configuration & customization of the software. I wouldn't recommend this device to people who want to save money. You can get a laptop with similar specs in about 30% of the Macbook's price. E.g. Thinkpad device. I also wouldn't recommend it to people who use external devices quite often. If you are using the external screen, mouse & keyboard lack of Apple touchpad and retina display shouldn't be a deal-breaker for you. I also wouldn't recommend it to people who use a lot of specific external devices. In the case of choosing Macbook, probably you'll need a lot of adapters and some stuff may not work fine for you. In addition, if you like to customize your system, probably you should get a Thinkpad device & install Linux. Moreover, you need to remember that Macbook Pro is not a gaming laptop. In my opinion, macOS is better than Windows for the type of programming I do (recently Java, Bash & Python). Nevertheless, I don't think it's better for that than Linux. As you see, using a Macbook Pro has pros and cons. You need to remember that choosing of the device should be dictated by **logic and pragmatism**. Not by marketing and fashion.
