# Perfect API Documentation Server

[![Perfect logo](http://www.perfect.org/github/Perfect_GH_header_854.jpg)](http://perfect.org/get-involved.html)

[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg)](https://github.com/PerfectlySoft/Perfect)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_2_Git.jpg)](https://gitter.im/PerfectlySoft/Perfect)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg)](https://twitter.com/perfectlysoft)
[![Perfect logo](http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg)](http://perfect.ly)


[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License Apache](https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat)](http://perfect.org/licensing.html)
[![Twitter](https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat)](http://twitter.com/PerfectlySoft)
[![Join the chat at https://gitter.im/PerfectlySoft/Perfect](https://img.shields.io/badge/Gitter-Join%20Chat-brightgreen.svg)](https://gitter.im/PerfectlySoft/Perfect?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Slack Status](http://perfect.ly/badge.svg)](http://perfect.ly) [![GitHub version](https://badge.fury.io/gh/PerfectlySoft%2FPerfect-CURL.svg)](https://badge.fury.io/gh/PerfectlySoft%2FPerfect-CURL)

## About the Perfect API Documentation Server

This project is a fully functioning API Documentation Service. An authenticated .

Data storage is via PostgreSQL 9.4+ and makes use of PostgreSQL's BSON column format for unstructured storage.

This package builds with Swift Package Manager and is part of the [Perfect](https://github.com/PerfectlySoft/Perfect) project.

Ensure you have installed and activated the latest Swift 3.0 tool chain.

## First run

The first time the server is run, it will attempt to create the tables and data structure, and a default user account.

This account's username is "admin" and the password is "perfect".

> It is **strongly recommended** that you create a new user for yourself, then delete this "admin" user account.

See the "Integration" section below for how to include support for Remote Logging to your Perfect server side application.

## Installation and setup


Please ensure you have installed Swift 3.0.2 or later before building this project.

Download the source and execute `swift build` in the project directory. This will build the executable binary. Executing `swift package generate-xcodeproj` will build the Xcode project file.

### Installation using Perfect Assistant

On the Perfect Assistant "Welcome" screen, click "Create New Project", and then "Custom Repository URL". Enter the URL as "https://github.com/PerfectServers/Perfect-LogServer", and choose a project location. 

Then, use the Perfect Assistant to build the project, create the Xcode project file, and deploy.

### PostgreSQL configuration

Please see the platform-specific build instructions for PostgreSQL at [https://www.perfect.org/docs/PostgreSQL.html](https://www.perfect.org/docs/PostgreSQL.html)

The configuration of the applicaton's database access is done by altering values in the `ApplicationConfiguration.json` file at the root of the project directory.

The contents in the default configuration are:

```
{
	"postgresdbname": "logserver",
	"postgreshost": "localhost",
	"postgresport": 5432,
	"postgrespwd": "perfect",
	"postgresuser": "perfect",
	"httpport": 8181
}
```

Adjust these values to those which will access your server and database.

When you are deploying the application to another server environment, make sure the `ApplicationConfiguration.json` file is in the correct location on the deployed system and change the values to suit.

## Sending log events to the API

Logging an event from your system to this log server is as simple as sending a POST request to a URL.

The URL will be in the form `{http://yourdomain.com}/api/v1/get/log/{token}`.

### Tokens 

To get a "token", visit the Tokens section of the web app, and create a token. The token will have an "id" that will look like `9c92ce91-010d-44b5-a44b-c088591cfeab` - copy that and use. Just remember that tokens must be marked "valid" to work.

"Expiring" a token will mean that events hitting your log server with that token will no longer be recorded.

### Applications

You can also group logs via "Applications". This means that you can assign an application several "tokens", or several applications to a token, and still see which application the event was triggered by.

To set up applications, visit the Applications section, and create an application. The new application will have an "id" that will look like `9c92ce91-010d-44b5-a44b-c088591cfeab` - copy that and use in your code! Just remember that tokens must be marked "valid" to work.

### Event "Payload"

When you send a POST request to your logging server, you also need to include a "payload" of information in the raw body of the request. This will look something like this:

```
{
	"appuuid":"88049d67-c105-47de-b728-62fbec0a2f0c",
	"eventid":"55049d67-c105-47de-b728-62fbec0a2f0c",
	"loglevel": "warn",
	"detail": {
		"ip":"127.0.0.1",
		"uuid":"88049d67-c105-47de-b728-62fbec0a2f0c",
		"user":"user@example.com",
		"header":"Event name, perhaps",
		"msg":"Some informative message.",
		"additional":"More detail?"
	}
}
```

The "appuuid", and "eventid" can be left empty, but the "loglevel" must be one of: debug, info, warn, error or critical.

The "detail" section is flexible JSON - it can be any valid name/value JSON information you wish to log. You can put as little or as much in there but bear in mind that the more you store, the more will be displayed on the user interface.

## Integration

### Perfect / Swift SPM Dependency

The "Perfect-Logging" dependency includes support for remote logging to this log server.

To include the dependency in your project, add the following to your project's Package.swift file:

``` swift
.Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
```

Now add the import directive to the file you wish to use the logging in:

``` swift 
import PerfectLogger
```
#### Configuration
Three configuration parameters are required:

``` swift
// Your token
RemoteLogger.token = "<your token>"

// App ID (Optional)
RemoteLogger.appid = "<your appid>"

// URL to access the log server. 
// Note, this is not the full API path, just the host and port.
RemoteLogger.logServer = "http://localhost:8181"

```


#### To log events to the log server:

``` swift
var obj = [String: Any]()
obj["one"] = "donkey"
RemoteLogger.critical(obj)
```

#### Linking events with "eventid"

Each log event returns an event id string. If an eventid string is supplied to the directive then it will use the supplied eventid in the log directive instead - this makes it easy to link together related events.

``` swift
let eid = RemoteLogger.critical(obj)
RemoteLogger.info(obj, eventid: eid)
```

The returned eventid is marked @discardableResult therefore can be safely ignored if not required for re-use.



## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)


## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
