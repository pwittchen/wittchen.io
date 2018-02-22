---
title: Fixing bug with dissappearing map overlay after zoom in Android
date: 2013-01-21 22:16:00
tags: android, java
---

In Android 3.0 – HoneyComb (API 11) or higher occurs specific bug connected with map overlay. When we draw overlay on the map (e.g. routes, directions or polylines) after zooming to particular level, overlay disappear unexpectedly. We can fix this bug very easily by disabling hardware acceleration for drawing overlays. Below, you can see exemplary code snippet with map injected by RoboGuice and disabled hardware acceleration. Changing way of drawing overlays should fix the bug.

```java
public class ExamplaryMapActivity extends RoboMapActivity {
  	@InjectView(R.id.mapview)
	private MapView mapView;

	@Override
	protected void onCreate(Bundle bundle) {
		enableHWAccel(mapView, false);
	}

	@TargetApi(11)
	private static void enableHWAccel(MapView mapView, boolean enable) {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			int type = enable ? View.LAYER_TYPE_HARDWARE : View.LAYER_TYPE_SOFTWARE;
			mapView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
		}
	}
}
```
