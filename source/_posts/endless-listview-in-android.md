---
title: Endless ListView in Android
date: 2013-02-14 15:34:00
tags: android
---

Some time ago, I had to implement Endless ListView in Android application. I checked different solutions, but some of them were overprogrammed or did not work well. Fortunately, I found simple solution, which solves the problem. Code snippet presenting mentioned approach, is placed below.

```java
public class EndlessScrollListener implements OnScrollListener {
	
    private int visibleThreshold = 20;
	private int currentPage = 0;
	
	@Override
	public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
	}
	
	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {
		if (scrollState == SCROLL_STATE_IDLE) {
			if (listView.getLastVisiblePosition() >= listView.getCount() - visibleThreshold) {
				currentPage++;
				downloadRecordsTask.setPage(currentPage);
				downloadRecordsTask.execute();
			}
		}
	}

}
```

In this solution, I simply implement OnScrollListener interface inside the activity, which is responsible for displaying the ListView (class presented above can be nested class in the proper activity class). In this case listView attribute represents ListView and downloadRecordsTask in an examplary AsyncTask. Of course, AsyncTask class should also have setPage method used for pagination. Records are loaded asynchronously to the listView, when user is not scrolling the list (`SCROLL_STATE_IDLE`). In my opinion, this solution is the simplest, the easiest to implement and works as we expect it to work. I have tested it in my project for over 1000 records and I have not encountered any problems during the testing process.
