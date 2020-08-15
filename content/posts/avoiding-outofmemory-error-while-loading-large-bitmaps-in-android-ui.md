---
title: Avoiding OutOfMemory Error while loading large Bitmaps in Android UI 
date: 2014-02-23 13:34:00
tags:
    - android
    - java
---

Sometimes we may encounter an error connected with loading too large Bitmaps into Android UI. In such cases, we may receive `OutOfMemoryError` in stack trace. In Android, we are working with limited memory and we shouldn't load images with full resolution into UI. These images should be scaled down in order to save memory and increase performance of the application. It's very well described in official Android documentation in section [Loading Large Bitmaps Efficiently](http://developer.android.com/training/displaying-bitmaps/load-bitmap.html "Loading Large Bitmaps Efficiently"). It's worth reading. We can deal with memory problem in three easy steps:

1.  Read image dimensions and type
2.  Scale down image
3.  Load scaled down version of the image to memory

Now, we are ready to display image in the UI. In Android documentation, available from the link placed above, you can find relevant code, which will help you to solve the problem. If you want to load image from file path instead of resources, you can use my code snippet available below. 

```java
public static Bitmap decodeSampledBitmap(String filePath, int reqWidth, int reqHeight) {
    final BitmapFactory.Options options = new BitmapFactory.Options();
    options.inJustDecodeBounds = true;
    BitmapFactory.decodeFile(filePath,options);
    options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
    options.inJustDecodeBounds = false;
    return BitmapFactory.decodeFile(filePath,options);
}
```

Source of the `calculateInSampleSize` method is available in [Android documentation](http://developer.android.com/training/displaying-bitmaps/load-bitmap.html). 

**Update:** There is a library, which solves this problem and provides caching. It's [Picasso](http://square.github.io/picasso/) from Square. I recommend to use this library especially, when you're dealing with a lot of images, ListViews and Adapters.
