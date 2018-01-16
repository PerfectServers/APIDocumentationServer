//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectRequestLogger
import PerfectSession
import PerfectSessionPostgreSQL
import PerfectCrypto
import PerfectLocalAuthentication

let _ = PerfectCrypto.isInitialized

#if os(Linux)
	let fileRoot = "/perfect-deployed/apidocumentationserver/"
	var httpPort = 8100
#else
	let fileRoot = ""
	var httpPort = 8181
#endif

var baseURL = ""

// Configuration of Session
SessionConfig.name = "APIDocServer"
SessionConfig.idle = 86400
SessionConfig.cookieDomain = "localhost"
SessionConfig.IPAddressLock = false
SessionConfig.userAgentLock = false
SessionConfig.CSRF.checkState = true
SessionConfig.CORS.enabled = true
SessionConfig.cookieSameSite = .lax

RequestLogFile.location = "./log.log"

let opts = initializeSchema()
httpPort = opts["httpPort"] as? Int ?? httpPort
baseURL = opts["baseURL"] as? String ?? baseURL

let sessionDriver = SessionPostgresDriver()

Config.runSetup()
APIGroup.runSetup()
APIDoc.runSetup()



// Defaults
var configTitle = Config.getVal("title","Perfect API Doc Server")
var configLogo = Config.getVal("logo","/images/perfect-logo-2-0.png")
var configLogoSrcSet = Config.getVal("logosrcset","/images/perfect-logo-2-0.png 1x, /images/perfect-logo-2-0.svg 2x")


var confData = [
	"servers": [
		[
			"name":"localhost",
			"port":httpPort,
			"routes":[],
			"filters":[
				[
					"type":"response",
					"priority":"high",
					"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				],
				[
					"type":"request",
					"priority":"high",
					"name":SessionPostgresFilter.filterAPIRequest,
					],
				[
					"type":"request",
					"priority":"high",
					"name":RequestLogger.filterAPIRequest,
					],
				[
					"type":"response",
					"priority":"high",
					"name":SessionPostgresFilter.filterAPIResponse,
					],
				[
					"type":"response",
					"priority":"high",
					"name":RequestLogger.filterAPIResponse,
					]
			]
		]
	]
]


// Add routes
confData["servers"]?[0]["routes"] = mainMonitorRoutes()


do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

