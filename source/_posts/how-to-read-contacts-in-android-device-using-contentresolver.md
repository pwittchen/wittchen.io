---
title: How to read contacts in Android device using ContentResolver? 
date: 2014-03-02 22:23:00
tags:
    - android
    - java
---

With [Content Providers](http://developer.android.com/guide/topics/providers/content-providers.html) we can access data stored by Android system applications. Popular example of using Content Provider is retrieving contact list from the smartphone. We can also access Calendar or create our own Content Provider. More information about that can be found in documentation of Android. If we want to access Content Provider, we can use [Content Resolver](http://developer.android.com/reference/android/content/ContentResolver.html) in our application's context.

In this example, we will access contact list. First of all, it’s good to create Contact entity class, which will be model of our data.

```java
public class Contact {
    public int id;
    public String name;
    public String phone;
    public String email;
    public String uriString;
}
```

We can access application’s context through GenericApplication class extending Application class.

```java
public class GenericApplication extends Application {
    private static Application instance;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }

    public static Context getContext() {
        return instance.getApplicationContext();
    }
}
```

We can use static application’s context in many situations. Nevertheless, we should avoid this practice when we work with UI and Views, because we may have problems with styles, look & feel of the application and other issues.

Now, we can create ContactsProvider class (we can call it as we want).

```java
public class ContactsProvider {

    private Uri QUERY_URI = ContactsContract.Contacts.CONTENT_URI;
    private String CONTACT_ID = ContactsContract.Contacts._ID;
    private String DISPLAY_NAME = ContactsContract.Contacts.DISPLAY_NAME;
    private Uri EMAIL_CONTENT_URI = ContactsContract.CommonDataKinds.Email.CONTENT_URI;
    private String EMAIL_CONTACT_ID = ContactsContract.CommonDataKinds.Email.CONTACT_ID;
    private String EMAIL_DATA = ContactsContract.CommonDataKinds.Email.DATA;
    private String HAS_PHONE_NUMBER = ContactsContract.Contacts.HAS_PHONE_NUMBER;
    private String PHONE_NUMBER = ContactsContract.CommonDataKinds.Phone.NUMBER;
    private Uri PHONE_CONTENT_URI = ContactsContract.CommonDataKinds.Phone.CONTENT_URI;
    private String PHONE_CONTACT_ID = ContactsContract.CommonDataKinds.Phone.CONTACT_ID;
    private String STARRED_CONTACT = ContactsContract.Contacts.STARRED;
    private ContentResolver contentResolver;

    public ContactsProvider() {
        contentResolver = GenericApplication.getContext().getContentResolver();
    }

    public List<Contact> getContacts() {
        List<Contact> contactList = new ArrayList<Contact>();
        String[] projection = new String[]{CONTACT_ID, DISPLAY_NAME, HAS_PHONE_NUMBER, STARRED_CONTACT};
        String selection = null;
        Cursor cursor = contentResolver.query(QUERY_URI, projection, selection, null, null);

        while (cursor.moveToNext()) {
            Contact contact = getContact(cursor);
            contactList.add(contact);
        }

        cursor.close();
        return contactList;
    }

    private Contact getContact(Cursor cursor) {
        String contactId = cursor.getString(cursor.getColumnIndex(CONTACT_ID));
        String name = (cursor.getString(cursor.getColumnIndex(DISPLAY_NAME)));
        Uri uri = Uri.withAppendedPath(QUERY_URI, String.valueOf(contactId));

        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(uri);
        String intentUriString = intent.toUri(0);

        Contact contact = new Contact();
        contact.id = Integer.valueOf(contactId);
        contact.name = name;
        contact.uriString = intentUriString;

        getPhone(cursor, contactId, contact);
        getEmail(contactId, contact);
        return contact;
    }

    private void getEmail(String contactId, Contact contact) {
        Cursor emailCursor = contentResolver.query(EMAIL_CONTENT_URI, null, EMAIL_CONTACT_ID + " = ?", new String[]{contactId}, null);
        while (emailCursor.moveToNext()) {
            String email = emailCursor.getString(emailCursor.getColumnIndex(EMAIL_DATA));
            if (!TextUtils.isEmpty(email)) {
                contact.email = email;
            }
        }
        emailCursor.close();
    }

    private void getPhone(Cursor cursor, String contactId, Contact contact) {
        int hasPhoneNumber = Integer.parseInt(cursor.getString(cursor.getColumnIndex(HAS_PHONE_NUMBER)));
        if (hasPhoneNumber > 0) {
            Cursor phoneCursor = contentResolver.query(PHONE_CONTENT_URI, null, PHONE_CONTACT_ID + " = ?", new String[]{contactId}, null);
            while (phoneCursor.moveToNext()) {
                String phoneNumber = phoneCursor.getString(phoneCursor.getColumnIndex(PHONE_NUMBER));
                contact.phone = phoneNumber;
            }
            phoneCursor.close();
        }
    }
}
```

We can filter our data, by manipulating selection parameter. E.g. if we want to retrieve only starred contacts, we can change “selection” parameter in the following way:

```java
String selection = STARRED_CONTACT + "='1'";
```

If we want to retrieve more or less data, we can manipulate “projection” parameter. ContentResolver is just kind of proxy for SQLite databases available in Android applications, which allows us to access this data in a safe way. We can use SQL language in order to select proper data. Check Android documentation for more details.

We also need to remember to add proper parameter to our `AndroidManifest.xml` file.

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

If we want to use GenericApplication class, we should also add proper attribute to `application` tag in `AndroidManifest.xml` file.

```xml
<application android:name="com.pwittchen.example.generics.GenericApplication">
```

That's it! 

Now, we can use our class to read contacts very easily. We can even create an [adapter](http://developer.android.com/reference/android/widget/Adapter.html) and display contacts on the list or do whatever we want to.
