---
title: Selected aspects of creating mobile Android applications
date: 2014-04-07 17:04:00
tags:
	- android
---
   
During the development of mobile applications, we should adjust our point of view to the specific projects we are working with. Applications for mobile devices are different than desktop or web applications. They have their own lifecycle, work on various devices with different screen resolutions. They have to work on devices with limited memory, clock rate of the CPU and battery life. In addition, these applications often have to be able to work without an Internet connection and their user interface has to be simple and well-designed due to smaller screen of a typical smartphone.

As we can see, there is a lot of limitations, but there are also plenty of new possibilities. We can use GPS and create location-aware applications. We can access Bluetooth and establish a connection with external devices. The interaction between the user and our application can be performed with a touch screen. We can even use accelerometer, built-in most of devices, as an alternative UI controller or we can use it for monitoring the activity of the user. New Android API have a feature called Activity Recognition, which allows to detect whether the user is walking, cycling, driving a car, etc. This function uses both GPS and accelerometer.
As we can see, the development of mobile applications has a lot of limitations, but it also brings a lot of new possibilities and uncovered areas, which have not been accessible before through traditional applications. Creating such projects can be a great challenge for every software developer. This article describes a few aspects of creating mobile applications, which can help to develop better projects and extend knowledge. Of course, it does not cover all the topics, but it is a good starting point for further research and development.

Dealing with activity lifecycle
-------------------------------

Before we start developing applications for Android platform, it is important to familiarise with Activity Lifecycle. As the documentation says an activity is a single, focused thing that the user can do and has its own screen and layout associated with it. We have to remember that while the user is using our application, he or she can receive phone call, SMS, push notification from another application, Internet connection can be lost, battery can be low, the phone will start turning off, etc. In addition, the user can rotate the screen of the device, what will cause recreation of the activity. Good practice is to create all important objects in onCreate(Bundle savedInstanceState) method. We have to remember that this method will not be called again, when running activity goes to the background and we call it for the second time. In such case, it will be moved to the top of the activity stack. If we want to execute specific methods every time when we call the activity (no matter, whether it is the first time or not), then we should execute them in onResume() method. Sometimes, the user provides some data into our application and we do not want to lose this data, when an unexpected event will occur. In such case, we can call methods responsible for saving the data and information about the application state in onPause() method. After that, we will be able to retrieve saved information in onResume() method in the future. In specific cases, we can handle configuration changes ourselves, if we want to prevent the recreation of the activity on screen rotation. It can be easily done by manipulating android:configChanges parameter of the activity in AndroidManifest.xml file. Value “orientation|keyboardHidden” will prevent the recreation of the activity. In newer versions of the API, we have to set this parameter to “orientation|keyboardHidden|screenSize”. It is not always necessary, but it is good to know that.

Context of the activity and application
---------------------------------------

Some methods of Android API, which are responsible for interaction with user interface or accessing resources of the application, requires Context type value as a parameter. Actually, we have two main types of the Context:
* Context of the specific Activity
* Context of the Application

The problem occurs, when we do not know, when to use which and why. In general, when we call the methods, which are responsible for interaction with the UI, we should use Context of the Activity. In addition, when we create custom views, we should also pass Context of the Activity into them. We should do it, because we may lose styles of our application and custom views will be rendered with default Android styles. We also should use this Context, when we perform actions strictly connected with the Activity. When we want to pass Context of the Activity inside Activity, we can simply use this keyword, which contains instance of the Activity, which also represents its Context.
There are situations, in which, we can use Context of the Application. It can be done when we access the resources of the application, file paths, strings, data defined in `*.xml` files and so on. Actually, we should use this context in each case, which is not explicitly related to Activity. In such situations, it is a good practice to create Generic Application and static context in order to standardise the way of accessing it and to be sure that we always access the same object. We can do it in the following way:

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

After that, we have to define GenericApplication in application tag in the `android:name` attribute.

```xml
<application android:name="com.futureprocessing.example.generics.GenericApplication">
```

Now, we will be able to access static Context of the application by calling GenericApplication.getContext() method from any place of our application.

Dependency Injection
--------------------

Dependency Injection as an implementation of Inversion of Control technique allows creating an abstract code with different implementations and follows the Dependency Inversion Principle. In this software design pattern dependent object have injected services. Dependency Injection separates the creation of objects from their behavior. The advantage of this solution is the fact that injected services can be loosely coupled. In addition, there is less lines of code and source of the project becomes clear. There are libraries for Android platform, which have functionality similar to popular Java frameworks dedicated to web applications. One of these solutions is RoboGuice. This is an annotation-based framework, which allows injecting views, resources, system services and POJOs. We do not have to create objects and cast views every time, because the framework will do it for us. Moreover, we can create custom bindings. This can be helpful in many situations. E.g. when one team is working on back-end application, providing web service with data and another team is working on mobile application, which should access this web service. In distributed teams, it may happen that the back-end team is a part of another company or work in a different country than mobile application team. Additionally, web service can be unfinished, but mobile team want to continue the work. In such case, we can create an interface with e.g. getData() method and mock web service implementing this interface. After that, we can bind our interface to mock web service and then inject the interface anywhere in the application. In such situation, application will be using mock data. When proper method responsible for retrieving the data from web service will be created, we can simply change the binding to real web service implementing aforementioned interface. This approach utilises Service Stub pattern, recommended by Martin Fowler. RoboGuice is a very comfortable and elegant solution, but its main drawback is the fact that it uses reflection and dependencies are created in runtime. When we have a lot of dependencies, it can slow down our application. When we face such problem, we can consider using Dagger, which does not use reflection, but generates java files containing dependencies. Those generated files can be compiled, so the application is not responsible for creating dependencies in runtime anymore. Dagger does not support injection of the views. If we want to inject them, we can use Butter Knife library, which is based on concept similar to Dagger.

Single Responsibility Principle
-------------------------------

Many tutorials and code samples of Android applications are not properly designed. There often is a lot of functionality contained inside single class extending Activity class. It is not a good practice, but in some cases it shows how specific functionality actually works and can be more understandable. Nevertheless, in real life, we should divide our code into smaller pieces, responsible for their own tasks to fulfill Single Responsibility Principle from SOLID concept, which will increase the quality of our code. It is better to understand this idea by looking at an example. Let’s implement a simple MVC pattern, delegate some functionality to the controller and display the result in activity. We can make an assumption that classes extending Activity will be responsible only for displaying the data and UI. Other methods will be accessed from other classes.
First of all, we need to create an interface for our activity.

```java
public interface SampleView {
    void displayData(String data);
}
```

Next, we have to create a controller, which will call the method from the class implementing previously created interface.

```java
public class SampleController {
    private SampleView view;

    public SampleController(SampleView view) {
        this.view = view;
    }

    public void generateData() {
        String generatedData = "Exemplary data generated by controller.";
        view.displayData(generatedData);
    }
}
```

Now, we are ready to create a class extending Activity class and implementing our interface. In this example, we are injecting view with RoboGuice, but we can use findViewById(int) method as well. We can create an object of the controller, assign to its constructor instance of current activity and execute the proper method. Then, the method inside the controller can access the activity through the interface, in order to display the results. Of course, we can call generateData() method anywhere (e.g. after clicking the button).

```java
public class SampleActivity extends Activity implements SampleView {
    @InjectView(R.id.sample_textview)
    private sampleTextView;

    private SampleController controller;

    @Override
    public displayData(String data) {
        sampleTextView.setText(data);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.controller = new SampleController(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        controller.generateData();
    }    
}
```

After these operations, in this short example we have separated an application logic and specific functions from the methods which operate on user interface. This is just a brief example of using MVC pattern. In bigger projects, we need to implement more complicated structures as well as create additional classes depending on specific cases and requirements.

Multithreading
--------------

Android API allows creating multithreaded applications. It is very useful, when we want our applications to do many things at the same time, when we want to create lazy loading solutions or run some tasks periodically in the background.

We can distinguish two main classes, which can be used for creating threads:
* Thread
* AsyncTask

These solutions can be used for different purposes.

A **Thread** is actually a concurrent unit of execution and it is built-in Java class. That is why, it is not Android-specific. In Android applications, we should use dedicated classes, but we can use Thread class, when we want to write concurrent application with lower level of abstraction. Thread object can be called from any thread with start() method. It runs on its own thread. Its drawback is manual thread management and not so good code readability.

**AsyncTask** is one of the most popular classes used for writing concurrent Android applications. It is usually used for long lasting tasks, which have to communicate with main thread or display the results in UI thread. This class should be used for task, which will be started, executed and finished while the user is accessing a single activity. AsyncTask can be called by execute() method from the main thread. It runs on a worker thread, but may be invoked by the main thread in order to publish the results or progress in the UI. One instance of this class can be executed only once. AsyncTask must be created and executed by the main thread. When activity creating AsyncTask will be destroyed, the thread also will be destroyed and the application will have to create and run it once again in the future.

Long running operations
-----------------------

Classes responsible for long running operations are confusing. They are sometimes classified as classes responsible for creating threads or processes, which is common mistake.

We can distinguish two main classes, which can be used for performing long running operations:
* Service
* IntentService extending Service

**Service** is application component used for running long-lasting tasks. It is neither thread nor process. It is also not connected with UI and should not last too long. We can execute threads (e.g. AsyncTask) within service for long task. In addition, Service can be run periodically. E.g. every 10 seconds, from the time it was started. It will be running even if our application will be send to the background until we decide to stop this thread. Service can be started by onStartService() method and can be executed from any thread. It also runs on the main thread, so a drawback of this class is the fact that it can block the main thread.

**IntentService** is a class extending Service class. It handles asynchronous requests on demand. It can be started by main thread and runs on separate worker thread. It cannot run tasks in parallel. As Android documentation says: 

> This “work queue processor” pattern is commonly used to offload tasks from an application’s main thread. The IntentService class exists to simplify this pattern and take care of the mechanics. To use it, extend IntentService and implement onHandleIntent(Intent). IntentService will receive the Intents, launch a worker thread, and stop the service as appropriate.

Summary
-------

Mobile Android applications are very specific projects, which are different than regular desktop or web applications. They have different lifecycle and different UI, but still some approaches are similar to traditional software solutions. Mobile applications and mobile devices have a lot of limitations. On the other hand, they have a lot of new features, functions and user interaction methods, which have not been available before, what brings new possibilities and fresh ideas. Regardless of the fact that they run on small devices, they are a great challenge for software developers and the future of today’s technology.

**Note**: This article was also published on the Technical Blog of Future Processing company at: 
https://www.future-processing.pl/blog/selected-aspects-of-creating-mobile-android-applications/
