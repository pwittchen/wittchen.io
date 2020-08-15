---
title: How to change Fragment layout on orientation change? 
date: 2013-08-15 22:50:00
tags:
    - android
    - java
---

When we work with Activities in Android, defining different layouts for different screen orientations is easy. The only thing we need to do, is to create two `*.xml` files with the same name for layouts in two separate directories (_res/layout/_ and _res/layout-land/_). In [Fragments](http://developer.android.com/guide/components/fragments.html) it's not that easy. In such case, we need to perform additional operations in order to achieve our goal. Fragment in Android is not re-inflated on configuration change, but we can recreate layout and repopulate view manually. We need to create two layouts for different orientations of the screen in the same way as for Activity:

*   `res/layout/my_fragment.xml`
*   `res/layout-land/my_fragment.xml`

Then, we need to put code shown below to our fragment. Of course, it requires little adjustments depending on concrete project.

```java
public class MyFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle bundle) {
        View view = inflater.inflate(R.layout.my_fragment, container, false);
        
        // Find your buttons in view, set up onclicks, set up callbacks to your parent fragment or activity here.
        
        // You can create ViewHolder or separate method for that.
        // example of accessing views: TextView textViewExample = (TextView) view.findViewById(R.id.text_view_example);
        // textViewExample.setText("example");
        
        return view;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        LayoutInflater inflater = LayoutInflater.from(getActivity());
        populateViewForOrientation(inflater, (ViewGroup) getView());
    }

    private void populateViewForOrientation(LayoutInflater inflater, ViewGroup viewGroup) {
        viewGroup.removeAllViewsInLayout();
        View subview = inflater.inflate(R.layout.my_fragment, viewGroup);

        // Find your buttons in subview, set up onclicks, set up callbacks to your parent fragment or activity here.
        
        // You can create ViewHolder or separate method for that.
        // example of accessing views: TextView textViewExample = (TextView) view.findViewById(R.id.text_view_example);
        // textViewExample.setText("example");
    }
}
```

That's it!
