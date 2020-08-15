---
title: NetworkEvents - Android library
date: 2014-08-19 14:59:00
tags:
- android
---

**Please note: This post is outdated. Check newest API on the [GitHub](https://github.com/pwittchen/NetworkEvents).**

Introduction
------------

NetworkEvents is an Android library, which I've created recently for one of the projects. It uses [Otto Event Bus](http://square.github.io/otto/) to support event driven programming. We can use appropriate annotations and perform any action, when connectivity status changes. E.g. when device will go offline, connects to the mobile network, connects to the WiFi network, connects to the WiFi network with Internet access or connects to WiFi network without Internet access. Android API does not allow to determine whether specific WiFi Access Point is connected to the Internet, but this library does. In addition, we can monitor change of the signal strength of available WiFi Access Points in the same manner as connectivity status.

Where can I get it?
-------------------

NetworkEvents library is open-source and available on GitHub at: [https://github.com/pwittchen/NetworkEvents](https://github.com/pwittchen/NetworkEvents). You can clone this repository and see how it works. It contains [sample project](https://github.com/pwittchen/NetworkEvents/tree/master/example) using library module dependency. Network Events library is placed in separate module. Android Studio is recommended IDE.

How to use it?
--------------

### 1\. Initialize EventBus and NetworkEvents

You can do it in `onCreate()` method of the activity in case of using library in activity.

```java
Bus bus = new Bus();
NetworkEvents networkEvents = new NetworkEvents(this, bus);
```

### 2\. Register/Unregister EventBus and NetworkEvents

```java
@Override
protected void onResume() {
  super.onResume();
  bus.register(this);
  networkEvents.register();
}

@Override
protected void onPause() {
  super.onPause();
  bus.unregister(this);
  networkEvents.unregister();
}
```

### 3\. Subscribe events

We can subscribe two or just one event. It depends on our needs.
The following events are available:

* `ConnectivityStatusChangedEvent`
* `WifiAccessPointsSignalStrengthChangedEvent`

Subscribing events is simple. Look at the code below.


```java
@Subscribe
public void connectivityStatusChanged(ConnectivityStatusChangedEvent event) {
  // you can perform here any action you want to
  // in this example we are displaying toast with Connectivity Status
  // and another toast with WiFi info

  Toast.makeText(this, event.getConnectivityStatus().toString(), Toast.LENGTH_SHORT).show();
  Toast.makeText(this, event.getWifiInfo().toString(), Toast.LENGTH_SHORT).show();
}

@Subscribe
public void wifiAccessPointsRefreshed(WifiAccessPointsSignalStrengthChangedEvent event) {
  // you can perform here any action you want to
  // in this example we are retrieving list of available access points
  // and storing it on the List

  WifiManager wifiManager = (WifiManager) getSystemService(Context.WIFI_SERVICE);
  List<ScanResult> accessPoints = wifiManager.getScanResults();
}
```

That’s it! For more details, check NetworkEvents project on GitHub at: https://github.com/pwittchen/NetworkEvents
`README.md` file also contains some details.

### Remarks

EventBus and NetworkEvents can be accessed via Singletons to avoid multiple instances of these classes.