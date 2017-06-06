//
//  userModAction.swift
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
	
	static func groupModAction(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAccountID = request.session?.userid ?? ""
			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty
			if !contextAuthenticated { response.redirect(path: "/login") }

			let obj = APIGroup()
			var msg = ""

			if let id = request.urlVariables["id"] {
				try? obj.get(id)

				if obj.id.isEmpty {
					redirectRequest(request, response, msg: "Invalid Group", template: "views/groups")
				}
			}


			if let name = request.param(name: "name"), !name.isEmpty,
				let displayorder = request.param(name: "displayorder"), !displayorder.isEmpty,
				let status = request.param(name: "status"), !status.isEmpty {
				obj.name = name
				obj.displayOrder = Int(displayorder) ?? 1000
				if status == "active" {
						obj.objectStatus = 1
				} else {
					obj.objectStatus = 0
				}

				if obj.id.isEmpty {
					obj.makeID()
					try? obj.create()
				} else {
					try? obj.save()
				}

			} else {
				msg = "Please enter the all the details."
				redirectRequest(request, response, msg: msg, template: "views/groups", additional: [
					"usermod?":"true",
					])
			}


			let list = APIGroup.listGroups()

			var context: [String : Any] = [
				"accountID": contextAccountID,
				"authenticated": contextAuthenticated,
				"grouplist?":"true",
				"groups": list,
				"msg": msg
			]
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
