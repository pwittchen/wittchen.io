---
title: Dynamic wallpaper for i3
tags:
  - i3
  - linux
date: 2020-03-29 20:29:36
---

Some time ago, I was using macOS. The thing I liked about this OS since Mojave version was the dynamic wallpaper feature. Wallpaper representing picture of the Mojave desert in California was dynamically changing during the day. In the morning, we could see the dawn and sunrise, later picture during the midday, in the evening, desert during the dusk and finally picture at night. I liked the fact that wallpaper were adjusting to the time of the day. I wanted to have the same thing on my Linux. Luckily, on Arch and i3, it's pretty easy to achieve.

I could create very simple bash script:

```bash
function setbg {
  cp $1 ~/.config/wall.jpg
  DISPLAY=:0.0 feh --bg-scale ~/.config/wall.jpg
  notify-send "wallpaper changed"
}

hour=$(date +%H)
time_of_day=$(sunwait poll 50.2849923N 18.6493647E)
[[ $time_of_day == "DAY" ]] && [ $hour -lt 12 ] && setbg $1 # morning
[ $hour -gt 11 ] && [ $hour -lt 15 ]            && setbg $2 # midday
[ $hour -gt 14 ] && [[ $time_of_day == "DAY" ]] && setbg $3 # dusk
[[ $time_of_day == "NIGHT" ]]                   && setbg $4 # night
```

In this example, I simply take the current hour and check if there's day or night inside `time_of_day` variable with `sunwait` program. It's pretty neat program and also allows to check time of the sunset and sunrise basing on our timezone and location. When `sunwait` generates wrong data, we can explicitly provide latitude and longitude for it. E.g `sunwait poll 50.2849923N 18.6493647E`. I'm using `feh` for setting my desktop background image with `DISPLAY=:0.0` instruction, which is required, when we want to execute our program in the cron job. Code snippet above is parametrized part of my larger [set_bg.sh](https://github.com/pwittchen/dotfiles/blob/master/.scripts/set_bg.sh) script, which you can find in my [dotfiles](https://github.com/pwittchen/dotfiles), but you can put direct paths to your wallpapers in it. You can also check my wrapper for this script in [set_bg_daynight.sh](https://github.com/pwittchen/dotfiles/blob/master/.scripts/set_bg_daynight.sh) file. In this case, we just need wallpapers for morning, midday, dusk and night. Of course, we can improve this script and introduce more parts of the day, but I didn't want to make it too complicated.

Once we are ready, we can put our script into `~/.config/i3/config` file, to set appropriate wallpaper after login:

```
exec --no-startup-id /path/to/our/script.sh
```

and create a cron job, which will update our wallpaper every hour:

```
1 * * * * /path/to/our/script.sh
```

That's all we need. Now, we can have macOS-like dynamic wallpapers on Linux and i3.

If you want to use macOS wallpapers from Mojave or Catalina OS version for this script, you can check [dynamic](https://github.com/pwittchen/wallpapers/tree/master/dynamic) directory of my [wallpapers](https://github.com/pwittchen/wallpapers) repository. You can also use any wallpapers you want for this script.
