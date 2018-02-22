---
title: Custom background for ActionBar and SherlockActionBar
date: 2013-02-01 22:31:00
tags: android
---

When you want to set custom background for Android ActionBar or SherlockActionBar instead of playing with your styles or views, you can use the following simple code snippet.

```java
@InjectResource(R.drawable.actionbar_custom_background)
private Drawable actionBarCustomBackground;

public void onCreate() {
  getSupportActionBar().setBackgroundDrawable(actionBarCustomBackground);
}
```

In this case, Drawable object is injected using RoboGuice library and set as a background for the ActionBar. In particular cases, you can use also getActionBar() method.
In Drawable object you can store an image of 1 px width and it will be stretched for 100% of width of the ActionBar.
I have tested the code snippet presented above for SherlockActionBar and it worked fine.
