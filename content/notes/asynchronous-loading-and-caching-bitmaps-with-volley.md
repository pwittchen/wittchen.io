---
title: Asynchronous loading and caching bitmaps with Volley 
date: 2013-08-26 23:37:00
tags:
    - android
    - java
---

We can use [Volley](https://android.googlesource.com/platform/frameworks/volley/) library from Google for very clean, simple and easy loading of the images from Internet. Volley uses [LRU cache](http://developer.android.com/reference/android/util/LruCache.html), so first of all, we need to create BitmapLruCache class extending LruCache class. 

```java
package com.github.volley.example.toolbox;

import com.android.volley.toolbox.ImageLoader.ImageCache;

import android.graphics.Bitmap;
import android.support.v4.util.LruCache;

public class BitmapLruCache extends LruCache<String, Bitmap> implements ImageCache {
    public BitmapLruCache(int maxSize) {
        super(maxSize);
    }

//    Fix thanks to Steven's comment: sizeOf method should not be overriden, 
//    when we are passing max image cache entries in another place of the code
//    @Override
//    protected int sizeOf(String key, Bitmap value) {
//        return value.getRowBytes() * value.getHeight();
//    }

    @Override
    public Bitmap getBitmap(String url) {
        return get(url);
    }

    @Override
    public void putBitmap(String url, Bitmap bitmap) {
        put(url, bitmap);
    }
}
```

Next, we need to create VolleyHelper class. 

```java
package com.github.volley.example.toolbox;

import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.Volley;
import com.github.volley.example.toolbox.BitmapLruCache;

/**
 * Helper class that is used to provide references to initialized RequestQueue(s) and ImageLoader(s)
 */
public class VolleyHelper {
    private static final int MAX_IMAGE_CACHE_ENTIRES  = 100;
    private static RequestQueue mRequestQueue;
    private static ImageLoader mImageLoader;

    private VolleyHelper() {
    }

    static void init(Context context) {
        mRequestQueue = Volley.newRequestQueue(context);
        mImageLoader = new ImageLoader(mRequestQueue, new BitmapLruCache(MAX_IMAGE_CACHE_ENTIRES));
    }

    public static RequestQueue getRequestQueue() {
        if (mRequestQueue != null) {
            return mRequestQueue;
        } else {
            throw new IllegalStateException("RequestQueue not initialized");
        }
    }

    /**
     * Returns instance of ImageLoader initialized with {@see FakeImageCache} which effectively means
     * that no memory caching is used. This is useful for images that you know that will be show
     * only once.
     */
    public static ImageLoader getImageLoader() {
        if (mImageLoader != null) {
            return mImageLoader;
        } else {
            throw new IllegalStateException("ImageLoader not initialized");
        }
    }
}
```

Then, somewhere in our activity, we can use the following code snippet: 

```java
imageView = (ImageView) findViewById(R.id.iv_image);

// ...

String imageUrl = "http://www.example.com/image.jpg";

VolleyHelper.init(this); // we can call this method in other place - e.g. in class extending Application class
                         // and refer to application context insted of activity context

ImageLoader imageLoader = VolleyHelper.getImageLoader();
imageLoader.get(imageUrl,ImageLoader.getImageListener(mImageView,R.drawable.no_image, R.drawable.error_image));

// ...
```

As we can see, we can define image in case of error or no image. What is nice and important, Volley will take care of asynchronous downloading of the bitmaps, so we don't have to create additional AsyncTasks. It will also create cache in temporary memory and on disk with using LRU cache. As we could easily notice, Volley is really good and small, but powerful library, which can make our life easier. It was also created and tested by Google, what assures its stability and quality.
