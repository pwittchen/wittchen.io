---
title: Detecting swipe gesture in mobile application
date: 2014-12-25 15:59:00
tags:
	- android
---

Introduction
------------

**Update**: Swipe Detector project is now called [swipe](https://github.com/pwittchen/swipe). 

Some time ago, I needed to detect moment when user is swiping finger on the screen horizontally (from left to right or opposite) or when user swiped horizontally. I've decided to spend some time for analyzing [onTouch(MotionEvent event)](http://developer.android.com/reference/android/view/View.OnTouchListener.html#onTouch(android.view.View, android.view.MotionEvent)) and `dispatchTouchEvent(MotionEvent event)` method. We can read more about differences between triggering onTouch eventes on [StackOverflow thread](http://stackoverflow.com/questions/9586032/android-difference-between-onintercepttouchevent-and-dispatchtouchevent). Method like `onTouch(MotionEvent event)` allows to trigger any touch event, but it doesn't allow to detect type of that event. Android API has [GestureDetector](http://developer.android.com/reference/android/view/GestureDetector.html) class, which allows to detect long press and double tap events. There is also [GestureDetector.OnGestureListener](http://developer.android.com/reference/android/view/GestureDetector.OnGestureListener.html) interface, which has the following methods:

*   `onDown(MotionEvent e)`
*   `onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY)`
*   `onLongPress(MotionEvent e)`
*   `onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY)`
*   `onShowPress(MotionEvent e)`
*   `onSingleTapUp(MotionEvent e)`

There is also [GestureDetector.SimpleOnGestureListener](http://developer.android.com/reference/android/view/GestureDetector.SimpleOnGestureListener.html) class implementing [GestureDetector.OnGestureListener](http://developer.android.com/reference/android/view/GestureDetector.OnGestureListener.html) and [GestureDetector.OnDoubleTapListener](http://developer.android.com/reference/android/view/GestureDetector.OnDoubleTapListener.html) interface. I also found an interesting project extending Android API called [better-gesture-detector](https://github.com/Polidea/better-gesture-detector).

Detecting swipe gesture
-----------------------

![swiped_right](/images/posts/2014/detecting-swipe-gesture-in-mobile-application/swipe.png)

Unfortunately, all of these solutions doesn't allow to detect swipe gestures (swipe left, right, up and down). That's why I've decided to create my own project, which allows to detect, whether user is currently swiping in a specific direction or if user already swiped. We can implement `SwipeListener` interface and do whatever we want, when desired event occurs. Check out [SwipeDetector](https://github.com/pwittchen/SwipeDetector) project on GitHub. If you want to see how swipe events are detected, browse source of [SwipeDetector](https://github.com/pwittchen/SwipeDetector/blob/master/app/src/main/java/pwittchen/com/swipedetector/SwipeDetector.java) class. If you want to see exemplary usage of this class, check out [SwipeDetectorActivity](https://github.com/pwittchen/SwipeDetector/blob/master/app/src/main/java/pwittchen/com/swipedetector/SwipeDetectorActivity.java). [SwipeDetector.SwipeListener](https://github.com/pwittchen/SwipeDetector/blob/master/app/src/main/java/pwittchen/com/swipedetector/SwipeDetector.java) interface allows to implement the following methods:

*   `onSwipingLeft(MotionEvent e)`
*   `onSwipedLeft(MotionEvent e)`
*   `onSwipingRight(MotionEvent e)`
*   `onSwipedRight(MotionEvent e)`
*   `onSwipingUp(MotionEvent e)`
*   `onSwipedUp(MotionEvent e)`
*   `onSwipingDown(MotionEvent e)`
*   `onSwipedDown(MotionEvent e)`

Moreover, we can take a look on a similar project called [better-gesture-detector](https://github.com/Polidea/better-gesture-detector), which recognizes more types of gestures and also can be useful. That's it. I hope, it will be useful in your projects as well.
