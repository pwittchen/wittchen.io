---
title: Introducing ReactiveSensors
date: 2015-09-05 20:03:00
tags:
- android
---

Another month, another library. Recently, I've released yet another reactive library called [ReactiveSensors](https://github.com/pwittchen/ReactiveSensors). It's an open-source Android library monitoring hardware sensors with RxJava Observables. Library is compatible with RxJava 1.0.+ and RxAndroid 1.0.+ and uses them under the hood.

Library is available at: [https://github.com/pwittchen/ReactiveSensors](https://github.com/pwittchen/ReactiveSensors).

In my opinion, hardware sensors are perfect case for applying RxJava, because in fact we're constantly receiving a stream of events emitted by many sensors. With Reactive Programming approach we have plenty of possibilities and easy API for manipulating received sensor's data.

Usage of the library is really simple. You just need to subscribe an Observable with RxJava in the same way like in any other reactive library.

Code sample below demonstrates how to observe Gyroscope sensor:

```java
new ReactiveSensors(context).observeSensor(Sensor.TYPE_GYROSCOPE)
    .subscribeOn(Schedulers.io())
    .filter(ReactiveSensorEvent.filterSensorChanged())
    .observeOn(AndroidSchedulers.mainThread())
    .subscribe(new Action1<ReactiveSensorEvent>() {
      @Override public void call(ReactiveSensorEvent reactiveSensorEvent) {
        SensorEvent event = reactiveSensorEvent.getSensorEvent();

        float x = event.values[0];
        float y = event.values[1];
        float z = event.values[2];

        String message = String.format("x = %f, y = %f, z = %f", x, y, z);

        Log.d("gyroscope readings", message);
      }
    });
}
```

Please note that we are filtering events occuring when sensors reading change with `ReactiveSensorEvent.filterSensorChanged()` method. There's also event describing change of sensor's accuracy, which can be filtered with `ReactiveSensorEvent.filterAccuracyChanged()` method. When we don't apply any filter, we will be notified both about sensor readings and accuracy changes.

We can observe **any hardware sensor** in the same way. You can check [list of all sensors in official Android documentation](http://developer.android.com/guide/topics/sensors/sensors_overview.html#sensors-intro).

I've created [section about Good Practices](https://github.com/pwittchen/ReactiveSensors#good-practices) regarding working with hardware sensors on Android in `README.md` file in the GitHub repository.You should also read an article about [Best Practices for Accessing and Using Sensors in official Android documentation](http://developer.android.com/guide/topics/sensors/sensors_overview.html#sensors-practices).

Read more in the `README.md` file located in the repository of the library at: [https://github.com/pwittchen/ReactiveSensors](https://github.com/pwittchen/ReactiveSensors).

You can also find JavaDoc at: [http://pwittchen.github.io/ReactiveSensors/](http://pwittchen.github.io/ReactiveSensors/).

If you want to use ReactiveSensors in your project, add the following dependency to your `build.gradle` file:

```gradle
dependencies {
  compile 'com.github.pwittchen:reactivesensors:0.0.1'
}
```

Feel free to send me feedback, report an issue or fork the library!
