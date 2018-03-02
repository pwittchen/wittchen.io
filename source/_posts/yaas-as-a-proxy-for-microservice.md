---
title: Basic usage of YaaS as a proxy for the microservice
date: 2017-04-30 22:45:00
tags:
	- yaas
	- hybris
	- proxy
	- microservices
---

Introduction
------------

The company, where I currently work - [SAP Hybris](http://hybris.com) is developing a project called [YaaS](https://www.yaas.io/), which is an abbreviation of Hybris as a Service. Unfortunately, this article is not sponsored yet :). What a pity :(. I just like to understand many things & how they work to see the bigger picture. Moreover, company strategy is to leverage YaaS and search for the new possibilities and use cases of this project. There are situations where delegating some work to a separate service makes sense so this knowledge may be useful even when we're developing the monolithic enterprise applications. That's why I wrote this article. I work in a completely different project - Enterprise Commerce Platform, where I'm the part of the Backoffice team. As you can read on the official website, _YaaS is a microservices ecosystem helping businesses to rapidly augment and build new, highly flexible solutions_. It's kind of marketing statement, which business people may like. Nevertheless, for developers, it's just a bunch of buzzwords, which does not help you to understand this project. One of the aims of this article is to explain it in a simple and clear way. [![yaas - hybris as a service](/images/posts/2017/yaas-as-a-proxy-for-microservice/yaas_header.jpg)](http://yaas.io) From **the technical point of view**, YaaS gives you the following possibilities:

*   it can be a proxy for your microservice, which can be deployed anywhere
*   it gives you separate proxy servers for EU and US, which you can use depending on the server or user location
*   it provides you a domain like `api.eu.yaas.io/yourorganization/yourservice/`
*   it provides secured connection
*   it gives a mechanism, which allows you to secure endpoints of your microservice via dynamically generated token
*   it gives you the possibility to manage access to your service for advanced use cases with features like clients, roles, etc.
*   it gives you monitoring possibilities
*   it allows you to perform versioning of your API
*   it allows you to integrate other services/packages from [YaaS Market](https://market.yaas.io/) with your service
*   it gives you web interface called [YaaS Builder](https://builder.yaas.io/), which you can use for managing your projects and organization

YaaS **is NOT**:

*   the hosting platform like Heroku or AWS - you need to have another place where you can deploy your service (like Heroku or whatever)
*   the part of the Core Hybris Platform - it's completely separate project, but it can be integrated with the Hybris Platform

The official website of the project is: [www.yaas.io](https://www.yaas.io/). In this article, I won't explain all the features of YaaS. I will simply show you:

*   how to create a simple proxy for your microservice
*   how to secure endpoint of your microservice
*   how to access secured endpoint of your microservice

Maybe I'll explain more features in the separate articles in the future.

Creating a simple proxy for the microservice
--------------------------------------------

We need to do the following steps:

1.  Go to [https://builder.yaas.io](https://builder.yaas.io)
2.  Create an account & log in
3.  Create an organization
4.  Create a project
5.  Within the project create a service
6.  Provide address to your service
7.  Provide API version (e.g. `v1`)
8.  Deploy service
9.  Right now, your service is deployed, but not accessible yet
10.  Create a Client and assign it to your service
11.  Now you should be able to access your service at: `https://api.eu.yaas.io/orgranization/service/v1`

Below you can see a screenshot from service configuration inside the YaaS Builder. 

![](/images/posts/2017/yaas-as-a-proxy-for-microservice/yass_builder_service.png)

Securing the endpoint of the microservice
-----------------------------------------

We have created our service. Now, we want to secure its endpoint. To do so, we can create Authorization Rule from the Service configuration inside YaaS Builder. 

![](/images/posts/2017/yaas-as-a-proxy-for-microservice/yaas_builder_rule.png)

We can define methods of the HTTP request, endpoint address, and other parameters. When we're done, we can proceed to more tricky part. Authorization procedure of the microservice endpoint is presented in the scheme below. 

![calling microservice with authorization via YaaS proxy](/images/posts/2017/yaas-as-a-proxy-for-microservice/calling_yaas_microservice_diagram.png)

First, we need to obtain Bearer ID. To do so, we need to perform HTTP request with Client ID and Client Secret. We can do it from terminal via curl:

```
curl -X POST -i 
-H "Content-Type: application/x-www-form-urlencoded" 
-d "grant_type=client_credentials&client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET" 
https://api.eu.yaas.io/hybris/oauth2/v1/token
```

Then, we'll receive a response like that:

```
{"token_type":"Bearer","access_token":"023-018f03da-cdb7-4710-a4cf-70f89e23003f","expires_in":3600,"scope":"hybris.tenant=pwtest"}
```

and we can make an authorized call to our microservice:

```
curl -X POST -i 
-H "Authorization: Bearer 023-018f03da-cdb7-4710-a4cf-70f89e23003f" 
-H "Content-Type: application/json" 
-d "" 
https://api.eu.yaas.io/pwittchen/test/v1/endpoint
```

after that, we should receive a response from the microservice. Note, that Bearer ID will be valid for the particular amount of time. **Hint #1**: To make calls more readable in the article, I split them into lines. If you're making a real call it's better to have whole instruction in **a single line**. **Hint #2**: You can get Client Secret and Client ID from the YaaS Builder while editing your Client.

Summary
-------

As we could see, creating a microservice proxy and securing the endpoint is not so complicated, but it's not straightforward as well. It requires some knowledge about YaaS and its design. Using this approach won't be a good idea every time, but I think there are use cases when it can be useful. Especially, when we care about monitoring & security and when we want to have unified & controlled access to our services. Here are a few of my ideas of delegating work to the microservice from the monolithic enterprise commerce application:

*   file or image storage
*   backups of the data
*   classification of the products - e.g. we can delegate images to the external service, which will use machine learning and neural networks to classify products by colors or by something else
*   long running operations & queues - e.g. we can delegate such things to the separate microservice to relieve CPU & Memory of the server, where core system is running and simply receive push notification with final result of the operation from the microservice when the work is done
*   sending e-mails and other types of notifications
*   and more... (if you have your own ideas - share them in comments!)

I think the basic idea could be the distribution of computations to the different servers, what may extend capabilities of the core system, make it faster, lighter and more stable. In addition, it should make work of developers easier and more joyful because they could work on the smaller parts of the system, which have a clearly specified goal and smaller codebase, which is easier to manage.
