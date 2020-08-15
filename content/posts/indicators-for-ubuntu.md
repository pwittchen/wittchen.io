---
title: Indicators for Ubuntu
date: 2014-09-07 20:47:00
tags:
- ubuntu
- linux
---

I recently found an article about [Best Useful Indicators Collection for Ubuntu](http://www.noobslab.com/2013/12/best-useful-indicators-collection-for.html). Indicators are very useful feature of the Ubuntu and Unity. Ubuntu has some default indicators, but we can add new indicators if we want to. Mentioned article contains list of many indicators, but personally I prefer and use only a few of them. Here are my favorites: 

![ubuntu_indicators](/posts/2014/indicators-for-ubuntu/ubuntu_indicators.png)

Multi Load indicator
--------------------

Nice thing. This indicator monitors system resources. E.g. usage of the processor, RAM, disk and network. We can customize it and set refresh interval. I found default low interval like 500 ms very disturbing, so I changed it to 5000 ms and it's ok for me. In the screenshot above, you can see blue chart for CPU usage, green chart for RAM usage and yellow chart for network usage. You can change, configure and customize it as you want. 

**Indicator can be installed by the following terminal commands:** 

```
sudo add-apt-repository ppa:indicator-multiload/stable-daily
sudo apt-get update
sudo apt-get install indicator-multiload
```

System Monitor indicator
------------------------

Useful indicator, which allows you to monitor temperature of your hardware components. It can monitor only those components, which have appropriate sensors. In my case I can monitor only CPU, but it is possible to monitor temperature of some GPUs and disks. If you don't want to overheat your processor, you should use such indicator. Of course, check specifications of your processor, its maximum and common temperature. Sometimes, it's necessary to clean computer inside or buy cooling stand in order to decrease CPU temperature. 

**Indicator can be installed by the following terminal commands:** 

```
sudo add-apt-repository ppa:noobslab/indicators
sudo apt-get update
sudo apt-get install indicator-sysmonitor
```

Indicator Sensors
-----------------

Indicator Sensors allows you to display temperature of your hardware sensors like CPU. In addition, you can set an alarm for situation where temperature of your hardware will exceed given value. 

**Indicator can be installed by the following terminal commands:** 

```
sudo add-apt-repository ppa:alexmurray/indicator-sensors
sudo apt-get update
sudo apt-get install indicator-sensors
```

My Weather indicator
--------------------

Indicator, which allows you to monitor current state of the weather. It can also display weather forecast for your city and display very detailed information about weather conditions. 

**Indicator can be installed by the following terminal commands:** 

```
sudo add-apt-repository ppa:atareao/atareao
sudo apt-get update
sudo apt-get install my-weather-indicator
```
