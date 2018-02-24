---
title: Reading/writing generic Java objects to JSON files and vice versa
date: 2014-08-27 21:19:00
tags:
	- java
---

Overview
--------

Recently, I have written small set of methods for a FileHelper using [Jackson library](http://jackson.codehaus.org/) in Android application, which allows to save [generic Java objects](http://en.wikipedia.org/wiki/Generics_in_Java) and list of generic objects in [JSON](http://en.wikipedia.org/wiki/JSON) format to a file and read them back in the original form. In the beginning I had some problems with saving and reading data properly. I could save and read data (e.g. list of the objects), but their type was [LinkedHashMap](http://docs.oracle.com/javase/6/docs/api/java/util/LinkedHashMap.html), which wasn't the list of desired generic objects. After adjusting Jackson library, I finally achieved my goal. You can see helper class below.

Helper class
------------

```java
/**
 * Helper is using Jackson library and Google Guava
 */
public class FileHelper {

    public static <Type> void saveObjectToFile(Object object, TypeReference<Type> type, String fileName) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(fileName);
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream, Charsets.UTF_8.name());
            Writer writer = new BufferedWriter(outputStreamWriter);
            mapper.writerWithType(type).writeValue(writer, object);
            fileOutputStream.close();
            outputStreamWriter.close();
            writer.close();
        } catch (FileNotFoundException exception) {
            exception.printStackTrace();
        } catch (IOException exception) {
            exception.printStackTrace();
        }
    }

    public static <ReturnedObject> ReturnedObject readObjectFromFile(String fileName, Class<ReturnedObject> returnedObjectClass) {
        ReturnedObject object = null;
        ObjectMapper mapper = new ObjectMapper();
        final JavaType type = mapper.getTypeFactory().constructType(returnedObjectClass);
        try {
            object = mapper.readValue(Files.toString(new File(fileName), Charsets.UTF_8), type);
        } catch (FileNotFoundException exception) {
            exception.printStackTrace();
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        return object;
    }

    public static <ReturnedObject> List<ReturnedObject> readObjectListFromFile(String fileName, Class<ReturnedObject> returnedObjectClass) {
        List<ReturnedObject> objectList = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper();
        final CollectionType collectionType = mapper.getTypeFactory().constructCollectionType(List.class, returnedObjectClass);
        try {
            objectList = mapper.readValue(Files.toString(new File(fileName), Charsets.UTF_8), collectionType);
        } catch (FileNotFoundException exception) {
            exception.printStackTrace();
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        return objectList;
    }

    public static boolean fileExists(String fileName) {
        File file =  new File(fileName);
        return file.exists();
    }
}
```

Usage
-----

You can use this helper in the following way:

```java
// initializing object and list of the objects
MyObject myObject = new MyObject();
List<MyObject> myObjectList = new ArrayList<>();

// saving object to file
FileHelper.saveObjectToFile(myObject, new TypeReference<MyObject>() {}, "my_object.json");

// reading object from file
MyObject myObjectRead = FileHelper.readObjectFromFile("my_object.json", MyObject.class);

// saving list of the objects to file
FileHelper.saveObjectToFile(myObjectList, new TypeReference<List<MyObject>>() {}, "list_of_my_objects.json");

// reading list of the objects from a file
List<MyObject> myObjectListRead = FileHelper.readObjectListFromFile("list_of_my_objects.json", MyObject.class);
```