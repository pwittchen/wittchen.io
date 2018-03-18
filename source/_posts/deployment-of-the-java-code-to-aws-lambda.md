---
title: Deployment of the Java code to AWS Lambda
tags:
  - aws
  - lambda
  - cloud
  - serverless
  - java
date: 2018-03-18 16:50:02
---


Introduction
------------

In the cloud computing era, companies start using services like Google Cloud Platform, Amazon Web Services or Microsoft Azure. We can hear about the term "Serverless". It doesn't mean that we don't have any servers. It means that third-party services provide us server infsrastrucutre, monitoring and scaling capabilities, so we don't have to care about that stuff by ourselves and we can focus on writing code. We have concepts like Backend as a Service (BaaS) and Funtion as a Service (FaaS). In BaaS we can configure whole backend infrastructure using third-party cloud services. In this case, we can have database, REST API and other services, which we need depending on our use case. In FaaS, we have just a tiny piece of code responsible for a single job, which we can take and deploy into the cloud. AWS Lambda is an example of FaaS and we'll focus on it in this article.

AWS Console
-----------

First of all, we need to create our AWS account to have an access to AWS console. You can find the console at: https://aws.amazon.com/console/. I had a few problems regarding registration, but finally I created my account. People in support are quite helpful. Please, keep in mind the fact, that you need to provide your debit card details during the registration and they'll charge you about 3 USD or something like that, which is a verification procedure. In AWS Lambda we'll get 1 million of free requests per month per cloud function, which is enough for tests or even not so demanding commercial services.

Serverless Framework
--------------------

[Serverless Framework](https://serverless.com/) is very convenient way of deploying Lambdas to AWS. You can install it as follows:

```
npm install serverless -g
```

Next, you can type:

```
serverless login
```

in order to log into Serverless. We can use `serverless` or `sls` alias for this tool.

We also need to **authorize** Serverless to be able to deploy our Lambdas to AWS. We need to go to AWS Console, in the upper right corner click our name of the user and choose "My Security Credentials". Then, we need to expand "Access Keys" and create new `key` and `secret` values. Once we got them, we can authorize Serverless:

```
sls config credentials --provider aws --key YOUR_KEY --secret YOUR_SECRET
```

Serverless will store these credentials in `~./aws/credentials` file. Of course, this is very simple configruation. If we need more users, groups or more sophisticated authorization mechanisms, we should apply them later via IAM (Identity and Access Management) service.

Creating Lambda
---------------

Next, we can create our AWS Lambda template. When, we type:

```
sls create --template
```

We will see the list of available templates:

```
Serverless: Generating boilerplate...

  Serverless Error ---------------------------------------

  Template "true" is not supported. Supported templates are: "aws-nodejs", 
  "aws-nodejs-typescript", "aws-nodejs-ecma-script", "aws-python", 
  "aws-python3", "aws-groovy-gradle", "aws-java-maven", 
  "aws-java-gradle", "aws-kotlin-jvm-maven", "aws-kotlin-jvm-gradle", 
  "aws-kotlin-nodejs-gradle", "aws-scala-sbt", "aws-csharp", "aws-fsharp", 
  "aws-go", "aws-go-dep", "azure-nodejs", "google-nodejs", "kubeless-python", 
  "kubeless-nodejs", "openwhisk-nodejs", "openwhisk-php", "openwhisk-python", 
  "openwhisk-swift", "spotinst-nodejs", "spotinst-python", "spotinst-ruby", 
  "spotinst-java8", "webtasks-nodejs", "plugin" and "hello-world".

  Get Support --------------------------------------------
     Docs:          docs.serverless.com
     Bugs:          github.com/serverless/serverless/issues
     Forums:        forum.serverless.com
     Chat:          gitter.im/serverless/serverless

  Your Environment Information -----------------------------
     OS:                     linux
     Node Version:           7.10.1
     Serverless Version:     1.26.0

```

We will use `aws-java-gradle` template:

```
sls create --template aws-java-gradle
```

After that, we'll get the following project structure:

```
├── build.gradle
├── gradle
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew
├── gradlew.bat
├── serverless.yml
└── src
    └── main
        ├── java
        │   └── com
        │       └── serverless
        │           ├── ApiGatewayResponse.java
        │           ├── Handler.java
        │           └── Response.java
        └── resources
            └── log4j.properties
```

If you want to browse source of such template, you can visit my [serverless-lambda-playground](https://github.com/pwittchen/serverless-lambda-playground) repo.
We can add our configurations in `serverless.yml` file:

```yml
service: aws-java-gradle

provider:
  name: aws
  runtime: java8

package:
  artifact: build/distributions/hello.zip

functions:
  hello:
    handler: com.serverless.Handler
```

Main class is the `Handler` class:

```java
public class Handler implements RequestHandler<Map<String, Object>, ApiGatewayResponse> {

  private static final Logger LOG = Logger.getLogger(Handler.class);

  @Override
  public ApiGatewayResponse handleRequest(Map<String, Object> input, Context context) {
	LOG.info("received: " + input);
	Response responseBody = new Response("Go Serverless v1.x! 
	Your function executed successfully!", input);
	return ApiGatewayResponse.builder()
			.setStatusCode(200)
			.setObjectBody(responseBody)
			.setHeaders(Collections.singletonMap("X-Powered-By", 
			"AWS Lambda & serverless"))
			.build();
	}
}
```

We can modify `handleRequest(Map<String, Object> input, Context context)` in order to perform any operation we want. It will be invoked after calling the Lambda.
In case of JVM projects, we need to build them first:


```
./gradlew build
```

Deployment to the Cloud
-----------------------

Next, we can deploy our Lambda to the AWS Cloud!

```
sls deploy
```

It may take more time in the beginning, but updates should be faster.

We should see something like that:

```
Serverless: Packaging service...
Serverless: Creating Stack...
Serverless: Checking Stack create progress...
.....
Serverless: Stack create finished...
Serverless: Uploading CloudFormation file to S3...
Serverless: Uploading artifacts...
Serverless: Validating template...
Serverless: Updating Stack...
Serverless: Checking Stack update progress...
...............
Serverless: Stack update finished...
Service Information
service: aws-java-gradle
stage: dev
region: us-east-1
stack: aws-java-gradle-dev
api keys:
  None
endpoints:
  None
functions:
  hello: aws-java-gradle-dev-hello
Serverless: Publish service to Serverless Platform...
Service successfully published! Your service details are available at:
https://platform.serverless.com/services/pwittchen/aws-java-gradle
```

Since that moment, our Lambda is deployed!

Be aware of the regions! I'm beginner with AWS, so I haven't noticed that my Lambda was deployed to `us-east-1` and I was checking it on the AWS console, while being switched to another region and I didn't know why I cannot see my function.

Now, we can log into AWS Console and Navigate to Lambda and then to Functions. We should see our function:

![](/images/posts/2018/deployment-of-the-java-code-to-aws-lambda/lambda-console.png)

When, we type:

```
sls info
```

We should see information about the Lambda:

```
Service Information
service: aws-java-gradle
stage: dev
region: us-east-1
stack: aws-java-gradle-dev
api keys:
  None
endpoints:
  None
functions:
  hello: aws-java-gradle-dev-hello
```

We can view details of our Lambda in AWS Console.

![](/images/posts/2018/deployment-of-the-java-code-to-aws-lambda/lambda-details.png)

Exposing Lambda via API Gateway
-------------------------------

We can also apply API Gateway to expose our Lambda to the external world.

![](/images/posts/2018/deployment-of-the-java-code-to-aws-lambda/api-gateway.png)

We can make our endpoint open or secured.

Next, we can expand Gateway details and we should find "Invoke URL". 

We can call it:

```
curl https://ipj76pb5yl.execute-api.us-east-1.amazonaws.com/prod/aws-java-gradle-dev-hello
```

Of course, url will be different in your setup.

After that, we should receive response:

```json
{
  "message": "Go Serverless v1.x! Your function executed successfully!",
  "input": {
    "resource": "/aws-java-gradle-dev-hello",
    "path": "/aws-java-gradle-dev-hello",
    "httpMethod": "GET",
    "headers": {
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.5",
      "CloudFront-Forwarded-Proto": "https",
      "CloudFront-Is-Desktop-Viewer": "true",
      "CloudFront-Is-Mobile-Viewer": "false",
      "CloudFront-Is-SmartTV-Viewer": "false",
      "CloudFront-Is-Tablet-Viewer": "false",
      "CloudFront-Viewer-Country": "PL",
      "Host": "ipj76pb5yl.execute-api.us-east-1.amazonaws.com",
      "upgrade-insecure-requests": "1",
      "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0",
      "Via": "2.0 a9e1c5fff6a2739d3f7026c216819292.cloudfront.net (CloudFront)",
      "X-Amz-Cf-Id": "mU9mJ_nnAMYSbqz_Iu2otYdSAG7wgW32HeVLGV388duttalquBZAHA==",
      "X-Amzn-Trace-Id": "Root=1-5aae6481-c429ef02c5f6dd6f25c4526a",
      "X-Forwarded-For": "85.14.99.231, 54.182.243.105",
      "X-Forwarded-Port": "443",
      "X-Forwarded-Proto": "https"
    },
    "queryStringParameters": null,
    "pathParameters": null,
    "stageVariables": null,
    "requestContext": {
      "requestTime": "18/Mar/2018:13:07:13 +0000",
      "path": "/prod/aws-java-gradle-dev-hello",
      "accountId": "782268757726",
      "protocol": "HTTP/1.1",
      "resourceId": "t56p8t",
      "stage": "prod",
      "requestTimeEpoch": 1521378433902,
      "requestId": "46b8b8fb-2aad-11e8-8a1b-0b0a282c605c",
      "identity": {
        "cognitoIdentityPoolId": null,
        "accountId": null,
        "cognitoIdentityId": null,
        "caller": null,
        "sourceIp": "85.14.99.231",
        "accessKey": null,
        "cognitoAuthenticationType": null,
        "cognitoAuthenticationProvider": null,
        "userArn": null,
        "userAgent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0",
        "user": null
      },
      "resourcePath": "/aws-java-gradle-dev-hello",
      "httpMethod": "GET",
      "apiId": "ipj76pb5yl"
    },
    "body": null,
    "isBase64Encoded": false
  }
}
```

Hooray! Our Lambda is working on-line now!

Monitoring
----------

In the "Monitoring" section of the AWS Lambda Functions Console, we can monitor usage of our service.

![](/images/posts/2018/deployment-of-the-java-code-to-aws-lambda/lambda-monitoring.png)

Update
------

If we want to update our function, we can simply modify it, rebuild code with `./gradlew build` and deploy it again with `sls deploy`. Once we have it configured it's really easy.

Function Removal
----------------

If we want to remove our Function, we can just type:

```
sls remove
```

and we'll see the following messages:

```
Serverless: Getting all objects in S3 bucket...
Serverless: Removing objects in S3 bucket...
Serverless: Removing Stack...
Serverless: Checking Stack removal progress...
.........
Serverless: Stack removal finished...
Serverless: Successfully archived your service on the Serverless Platform
```

Summary
-------

To wrap up, AWS Lambda is a really convenient way to solve single tasks without worrying about infrastructure, deployment and scalability. If we need one job to be done - e.g. exposing endpoint, transforming images, sending notifications, tiny app running on the server or whatever is required, AWS Lambda is good choice for that. Moreover, thanks to Serverless Framework deployment becomes really easy. In addition, we can develop Lambdas in other languages like Kotlin, Groovy, Scala, Go, Python, Node.js, C# and F#, so we're not limited just to one language. We also should remember that AWS is powerfull platform with about 100 different services and Lambda is just one of them. It's good to familiarize with AWS and other cloud computing platforms like Azure, GCP and so on because more companies start to invest in that and such solutions are becoming standard in certain areas.

References
----------
- [Serverless Architecture by Martin Fowler](https://martinfowler.com/articles/serverless.html)
- [AWS + Serverless - video tutorial](https://www.youtube.com/watch?v=71cd5XerKss)
- [AWS Console](https://console.aws.amazon.com)
- [Serverless Framework](https://serverless.com/)
- [Serverless Lambda Playground repository](https://github.com/pwittchen/serverless-lambda-playground)
