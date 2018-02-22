---
title: Custom fonts in Android
date: 2013-01-31 23:45:00
tags: android
---

Using custom fonts in Android is quite simple, but requires to do some things programmatically and cannot be done using only XML file defining the view. Let's have a look on an example. Here we have a simple Android view file: 

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  android:orientation="vertical"
  android:layout_width="fill_parent"
  android:layout_height="fill_parent" >
      <TextView
      android:id="@+id/custom_font"
      android:layout_width="fill_parent"
      android:layout_height="wrap_content"
      android:text="This is our custom font" />
</LinearLayout>
```

We want to use custom font for the TextView element with id: _custom_font_. Firstly, we have to put our font (in this example: _Custom_Font.ttf_) into the _./assets_ directory (create it if it doesn’t exist yet) in the main directory of the project. Then, we can use the following code: 

```java
TextView txt = (TextView) findViewById(R.id.custom_font);
Typeface font = Typeface.createFromAsset(getAssets(), "Custom_Font.ttf");
txt.setTypeface(font);
```

Please note, that Android does not fully support fonts in _*.otf_ format, so it's safer to use _*.ttf_ format instead. If we have font only in _*.otf_ format, we can use [one of the free font converters](http://www.freefontconverter.com/) in order to obtain desired and proper file extension. When we use the same font in whole application or a lot of elements in our project should use it, we can create custom TextView. The only thing, we have to do, is to create an additional class extending default TextView class. 

```java
public class MyEditText extends EditText{

    public MyEditView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public MyEditView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public MyEditView(Context context) {
        super(context);
        init();
    }

    private void init() {
        if (!isInEditMode()) {
            Typeface tf = Typeface.createFromAsset(getContext().getAssets(), "font.ttf");
            setTypeface(tf);
        }
    }

}
```

Note: _isInEditMode()_ method is used for graphical preview of the UI in Eclipse IDE. Afterwards, inside the view in the XML file, we should replace default TextView with our custom TextView like in the example below. 

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  android:orientation="vertical"
  android:layout_width="fill_parent"
  android:layout_height="fill_parent" >
      <com.myapp.widget.MyEditText
      android:id="@+id/custom_font"
      android:layout_width="fill_parent"
      android:layout_height="wrap_content"
      android:text="This is our custom font" />
</LinearLayout>
```

You can create other custom widgets respectively. E.g. _MyButton_, _MyCheckBox_, etc. It can be useful, when you want to unify fonts in your application taking into consideration older versions of the Android. Please note, that [Roboto](http://developer.android.com/design/style/typography.html) font was introduced in Android Ice Cream Sandwich, but luckily is free and available for download from official Google website. **Further reading & references:**

*   [http://mobile.tutsplus.com/tutorials/android/customize-android-fonts/](http://mobile.tutsplus.com/tutorials/android/customize-android-fonts/)
*   [http://stackoverflow.com/questions/7123833/customize-android-fonts](http://stackoverflow.com/questions/7123833/customize-android-fonts)
*   [http://stackoverflow.com/questions/10766943/change-font-for-edittext-in-android](http://stackoverflow.com/questions/10766943/change-font-for-edittext-in-android)

**Update**: There is a library, which simplifies described process. Check it out here: [https://github.com/ikocijan/MagicViews](https://github.com/ikocijan/MagicViews).
