---
title: Weather Icons for Android applications
date: 2014-10-02 21:18:00
tags:
	- android
---

Some time ago I found [Weather Icons](https://github.com/erikflowers/weather-icons/) project by [Erik Flowers](https://github.com/erikflowers). It's customized font with appropriate CSS, which allows you to use weather icons on the website. In addition, those icons can be customized. They can have different size or color. Moreover, they are compatible with the [Bootstrap](http://getbootstrap.com/). I thought, that it would be nice, if I had something like that for Android applications. That's why I created simple open-source project called [Weather Icon View](https://github.com/pwittchen/WeatherIconView). It's customized view for Android, which allows you to use weather icons in mobile apps in similar way as in web apps. When you add mentioned library to your project, you can use it in XML layout in the following way: 

```xml
<com.github.pwittchen.weathericonview.WeatherIconView
    android:id="@+id/my_weather_icon"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    custom:weatherIconResource="@string/wi_day_sunny"
    custom:weatherIconColor="@android:color/black"
    custom:weatherIconSize="200" />
```

You can also use it programmatically as it's presented below. 

```java
WeatherIconView weatherIconView;
weatherIconView = (WeatherIconView) findViewById(R.id.my_weather_icon);
weatherIconView.setIconResource(getString(R.string.wi_day_sunny));
weatherIconView.setIconSize(200);
weatherIconView.setIconColor(Color.BLACK);
```

Icons reference can be found at: [http://erikflowers.github.io/weather-icons/](http://erikflowers.github.io/weather-icons/)
For more details visit: [https://github.com/pwittchen/WeatherIconView](https://github.com/pwittchen/WeatherIconView).