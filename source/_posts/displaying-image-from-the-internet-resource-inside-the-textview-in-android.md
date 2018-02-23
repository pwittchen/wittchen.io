---
title: Displaying image from the Internet resource inside the TextView in Android 
date: 2013-03-19 23:04:00
tags:
    - android
---

Sometimes, we have to work with legacy code and we have to change application's behavior without modifying layouts, structure of the application and core components. Such situations can force us to do some tricks during development or maintenance process. For example, at the beginning, our app had to download data from the web service or RSS channel. This data consisted of the text, so we could use _TextView_ in order to display such information. After some time, back-end developers decided to put there some HTML code including references to images. We want to display images in our mobile application without modifying existing structure, so we can create data of type _Drawable_ inside the _TextView_. We can do it by creating an additional method _getImageHTML()_ and using [_fromHtml_](http://developer.android.com/reference/android/text/Html.html#fromHtml(java.lang.String)) method from [_Html_ class](http://developer.android.com/reference/android/text/Html.html), which is default Android class. Below, you can see an example presenting approach described in this post.

```java
public class FromHtmlImageActivity extends Activity {
    
	private TextView sampleTextView;
	private Spanned spannedValue;
	private String stringWithHtml;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		stringWithHtml = "Sample string with an <a href=\"http://www.exemplary-link.com\">exemplary link</a>.";
		spannedValue = Html.fromHtml(stringWithHtml,getImageHTML(),null);
		sampleTextView = (TextView)findViewById(R.id.sample_textview);
		sampleTextView.setText(spannedValue);
    	}
 
    	public ImageGetter getImageHTML() {
		ImageGetter imageGetter = new ImageGetter() {
			public Drawable getDrawable(String source) {
				try {
					Drawable drawable = Drawable.createFromStream(new URL(source).openStream(), "src name");
					drawable.setBounds(0, 0, drawable.getIntrinsicWidth(),drawable.getIntrinsicHeight());
					return drawable;
				} catch(IOException exception) {
					Log.v("IOException",exception.getMessage());
					return null;
				}
			}
		};
		return imageGetter;
	}
}
```
