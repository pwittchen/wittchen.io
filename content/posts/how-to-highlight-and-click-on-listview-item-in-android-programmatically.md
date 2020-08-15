---
title: How to highlight and click on ListView item in Android programmatically? 
date: 2014-03-06 21:43:00
tags:
    - android
    - java
---

There are many approaches concerning selecting items on Android's ListView. Unfortunately most of them don't work. I was struggling with this problem for some time and decided to publish my solution, which is actually quite easy.

The problem
-----------

I want to highlight item on a ListView programmatically (in a source code - without touching item on the screen).
I also want to click on item of the ListView programmatically.

Solution
--------

We have to create our own adapter. Let's call it ContactsAdapter.

```java
public class ContactsAdapter extends BaseAdapter {

    private final ArrayList list;
    private int selectedItem = -1; // no item selected by default

    // put neccessary code here - it's not important in this description

    public ContactsAdapter(List<Contact> contacts) {
        list = new ArrayList();
        list.addAll(contacts);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final View result;

        if (convertView == null) {
            result = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_contact, parent, false);
        } else {
            result = convertView;
        }

        highlightItem(position, result);

        Contact contact = getItem(position);
        ((TextView) result.findViewById(android.R.id.text1)).setText(contact.name);
        return result;
    }

    /**
     * methods from StringUtils calls:
     * getContext().getResources().getColor(int resourceId)
     * getContext().getResources().getDrawable(int resourceId)
     * You can use them in your own context 
     * (e.g. generic application context or you can pass activity context)
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private void highlightItem(int position, View result) {
        if(position == selectedItem) {
            // you can define your own color of selected item here
            result.setBackgroundColor(StringUtils.getColorFromResources(R.color.light_blue));
        } else {
            // you can define your own default selector here
            result.setBackground(StringUtils.getDrawableFromResources(R.drawable.abs__list_selector_holo_light));
        }
    }
    
    public void setSelectedItem(int selectedItem) {
        this.selectedItem = selectedItem;
    }

    // put rest of your necessary code here...

}
```

Important methods are:

* `View getView(int position, View convertView, ViewGroup parent)` - returns View of the single list item on the given position
* `void highlightItem(int position, View result)` - highlights item on a given position (sets proper background)
* `public void setSelectedItem(int selectedItem)` - sets item to highlight

Now, we have to set our adapter in a ListView in activity.

```java
@Override
protected void onResume() {
    List<Contact> contacts = getContactsFromYourSource();
    ContactsAdapter contactsAdapter = new ContactsAdapter(contacts);
    contactListView.setAdapter(contactsAdapter);
    highlightListItem(2); // this simple function call does the trick
}

private void highlightListItem(int position) {
    ContactsAdapter contactsAdapter = (ContactsAdapter) contactListView.getAdapter();
    contactsAdapter.setSelectedItem(position);
    // in some cases, it may be necessary to re-set adapter (as in the line below)
    contactListView.setAdapter(contactsAdapter);
}
```

In this example, `highlightListItem(int)` method will highlight chosen item on a `ListView` available in a variable `contactListView`.

**Clicking programmatically** is much more easier, than highlighting item. We can simply use the method below assuming, that we properly created contactListView attribute and assigned it to appropriate view.

```java
private void clickOnListItem(int position) {
    contactList.performItemClick(contactListView, position, contactListView.getItemIdAtPosition(position));
}
```
