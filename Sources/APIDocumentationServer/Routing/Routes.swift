//
//  WebHandlers.swift
//  Perfect-OAuth2-Server
//
//  Created by Jonathan Guthrie on 2017-02-06.
//
//

import PerfectHTTPServer
import PerfectLocalAuthentication

func mainMonitorRoutes() -> [[String: Any]] {

	var routes: [[String: Any]] = [[String: Any]]()

	// WEB
	routes.append(["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
	               "documentRoot":"./webroot",
	               "allowResponseFilters":true])
	routes.append(["method":"get", "uri":"/", "handler":WebHandlers.home])

	// Auth
	routes.append(["method":"get", "uri":"/login", "handler":LocalAuthWebHandlers.main])
	routes.append(["method":"post", "uri":"/login", "handler":LocalAuthWebHandlers.login])
	routes.append(["method":"get", "uri":"/logout", "handler":LocalAuthWebHandlers.logout])


	// Users
	routes.append(["method":"get", "uri":"/users", "handler":WebHandlers.userList])
	routes.append(["method":"get", "uri":"/users/create", "handler":WebHandlers.userMod])
	routes.append(["method":"get", "uri":"/users/{id}/edit", "handler":WebHandlers.userMod])
	routes.append(["method":"post", "uri":"/users/create", "handler":WebHandlers.userModAction])
	routes.append(["method":"post", "uri":"/users/{id}/edit", "handler":WebHandlers.userModAction])
	routes.append(["method":"delete", "uri":"/users/{id}/delete", "handler":WebHandlers.userDelete])

	// Config
	routes.append(["method":"get", "uri":"/config", "handler":WebHandlers.configGet])
	routes.append(["method":"post", "uri":"/config", "handler":WebHandlers.configSave])

	// Groups
	routes.append(["method":"post", "uri":"/api/v1/groups/create", "handler":WebHandlers.groupCreate])
	// web routes
	routes.append(["method":"get", "uri":"/groups", "handler":WebHandlers.groupList])
	routes.append(["method":"get", "uri":"/groups/create", "handler":WebHandlers.groupMod])
	routes.append(["method":"get", "uri":"/groups/{id}/edit", "handler":WebHandlers.groupMod])
	routes.append(["method":"post", "uri":"/groups/create", "handler":WebHandlers.groupModAction])
	routes.append(["method":"post", "uri":"/groups/{id}/edit", "handler":WebHandlers.groupModAction])
	routes.append(["method":"delete", "uri":"/groups/{id}/delete", "handler":WebHandlers.groupDelete])


	// Docs
	routes.append(["method":"post", "uri":"/api/v1/docs/create", "handler":WebHandlers.docCreate])
	routes.append(["method":"post", "uri":"/api/v1/docs/save/doc", "handler":WebHandlers.docSaveDoc])
	routes.append(["method":"post", "uri":"/api/v1/docs/save/usage", "handler":WebHandlers.docSaveUsage])



	return routes
}
