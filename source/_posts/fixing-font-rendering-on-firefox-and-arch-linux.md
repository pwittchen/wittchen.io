---
title: Fixing font rendering on Firefox and Arch Linux
tags:
  - firefox
  - arch
  - linux
date: 2019-11-01 11:57:02
---


After the recent Firefox update (70.0.1 64-bit), I've got a problem with font rendering on Arch Linux. I've installed this update probably on 31.10.2019 or 01.11.2019 (I'm not exactly sure right now). On several pages (e.g. Facebook or Github) fonts weren't rendered correctly. It looked like fonts without anti-aliasing what was quite ugly.

I figured out that I can go to the Firefox Settings and in the "Fonts and Colors" section, go to "Advanced" and turn off the option "Allow pages to choose their own fonts, instead of your selection above". It fixes problem with ugly fonts on several websites, but rest of the websites is not able to render the right fonts. E.g. when you have website with custom fonts from fonts.google.com (like this website). That's why I couldn't proceed with this solution.

I looked up style and font family on websites with ugly fonts  with Developer Tools and I figured out that messed up font is usually `Helvetica`. I've done some search and found [ephifonts-no-helvetica](https://aur.archlinux.org/packages/ephifonts-no-helvetica/) package on [AUR](https://aur.archlinux.org/), which has the following description:

```
Like ephifonts, less Helvetica that messes up fonts in Firefox and Chromium.
```

That's what I need!

I used my own AUR helper called [aur.sh](https://github.com/pwittchen/aur.sh) (check it out by the way if you're on Arch ;-) to install this package as follows:

```
aur get ephifonts-no-helvetica
```

Then I restarted Firefox and problem was finally solved. All websites were rendering fonts correctly thanks to freshly installed font package.
