---
title: Justifying block of text inside TextView in Android 
date: 2013-08-31 22:14:00
tags:
    - android
---

Justifying text inside `TextView` in Android is not that simple as we may expect it to be. Unfortunately, Android does not have attribute for `TextView`, which supports justifying text. We can set alignment to the right or to the left, but we cannot simply justify text with generic attributes. In order to do that, we need to perform a few tricks. First of all, we need to create file named `justified_textview.css` and we need to put it into the `assets/` directory of our project. We will use it later in our custom view. Source code of this CSS stylesheet is presented below: 

```css
body {
    font-size: 1.0em;
    color: rgb(0,0,0);
    text-align: justify;
    /* background: rgba(217, 217, 217, 1.0);  you can set your background here,
                                              it's kind of fix for older versions of Android OS */
}

@media screen and (-webkit-device-pixel-ratio: 1.5) {
    /* CSS for high-density screens */
    body {
        font-size: 1.05em;
    }
}

@media screen and (-webkit-device-pixel-ratio: 2.0) {
    /* CSS for extra high-density screens */
    body {
        font-size: 1.1em;
    }
}
```

Next, we need to create class for customized view extending WebView. Let's call it _JustifiedTextView_. 

```java
package com.github.sample.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Color;
import android.os.Build;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;
import android.webkit.WebView;

import com.github.sample.R;

public class JustifiedTextView extends WebView {

    private String text;

    public JustifiedTextView(final Context context) {
        this(context, null, 0);
    }

    public JustifiedTextView(final Context context, final AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public JustifiedTextView(final Context context, final AttributeSet attrs, final int defStyle) {
        super(context, attrs, defStyle);

        if (attrs != null) {
            final TypedValue typedValue = new TypedValue();
            final TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.JustifiedTextView, defStyle, 0);
            if (typedArray != null) {
                typedArray.getValue(R.styleable.JustifiedTextView_text, typedValue);

                if (typedValue.resourceId > 0 && TextUtils.isEmpty(text)) {
                    text = context.getString(typedValue.resourceId);
                    text.replace("\n", "<br />");
                    loadDataWithBaseURL("file:///android_asset/", "<html><head>" +
                            "<link rel=\"stylesheet\" type=\"text/css\" href=\"justified_textview.css\" />" +
                            "</head><body>" + text + "</body></html>", "text/html", "UTF8", null);
                }

                setTransparentBackground();
            }
        }
    }

    public void setTransparentBackground() {
        if (Build.VERSION.SDK_INT >= 11) {
            try {
                setLayerType(View.LAYER_TYPE_SOFTWARE, null);
            } catch (final NoSuchMethodError e) {
            }

            setBackgroundColor(Color.TRANSPARENT);
            setBackgroundDrawable(null);
            setBackgroundResource(0);
        }
    }

    public String getText() {
        return text;
    }

    public void setText(String currentText) {
        this.text = currentText;
        text.replace("\n", "<br />");
        loadDataWithBaseURL("file:///android_asset/", "<html><head>" +
                "<link rel=\"stylesheet\" type=\"text/css\" href=\"justified_textview.css\" />" +
                "</head><body>" + text + "</body></html>", "text/html", "UTF8", null);

        setTransparentBackground();
    }
}
```

After that, we need to update `res/values/attrs.xml` file and put inside the following declaration: 

```xml
<declare-styleable name="JustifiedTextView">
    <attr name="text" format="reference" />
</declare-styleable>
```

Now, we are ready to use our custom `JustifiedTextView`. In order to do that, we need to create layout containing `JustifiedTextView` as follows: 

```xml
<com.github.sample.view.JustifiedTextView
            android:id="@+id/tv_information"
            android:layout_width="wrap_content"
android:layout_height="wrap_content" />
```

Next, we can access `JustifiedTextView` in our activity: 

```java
// ...

private JustifiedTextView tvInformation;

public void onCreate() {
	tvInformation = (JustifiedTextView) findViewById(R.id.tv_information);
	tVinformation.setText("sample text");
}

// ...
```

We can also set text inside XML layout instead of doing this programmatically. It depends on our project. We also should turn off hardware acceleration for given activity in `AndroidManifest.xml` file in order to bring this solution to work. 

```xml
<activity
    android:name=".activity.justifiedTextViewActivity"
    android:configChanges="orientation|keyboardHidden"
android:hardwareAccelerated="false"/>
```

That's it. It's not perfect solution and it's kind of workaround, but I haven't found any better idea how to deal with this problem. I tested a few solutions and this one is, in my opinion, the best available and most elegant option for now. **Please note: There may be a problem with proper execution of this solution on Android OS version lower than 3.0 (API 11).**
