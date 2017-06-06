//
//  userMod.swift
//  ServerMonitor
//
//  Created by Jonathan Guthrie on 2017-04-30.
//
//


import SwiftMoment
import PerfectHTTP
import PerfectLogger
import LocalAuthentication


extension WebHandlers {

	static func groupMod(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAccountID = request.session?.userid ?? ""
			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty
			if !contextAuthenticated { response.redirect(path: "/login") }

			let obj = APIGroup()
			var action = "Create"

			if let id = request.urlVariables["id"] {
				try? obj.get(id)

				if obj.id.isEmpty {
					redirectRequest(request, response, msg: "Invalid Group", template: "views/groups")
				}

				action = "Edit"
			}


			var context: [String : Any] = [
				"accountID": contextAccountID,
				"authenticated": contextAuthenticated,
				"groupmod?":"true",
				"action": action,
				"name": obj.name,
				"displayorder": obj.displayOrder,
				"id": obj.id
			]

			if obj.objectStatus == 1 {
				context["objectactive"] = " selected=\"selected\""
			} else {
				context["objectinactive"] = " selected=\"selected\""
			}

			if contextAuthenticated {
				for i in WebHandlers.extras(request) {
					context[i.0] = i.1
				}
			}
			// add app config vars
			for i in WebHandlers.appExtras(request) {
				context[i.0] = i.1
			}
			response.render(template: "views/groups", context: context)
		}
	}

}
