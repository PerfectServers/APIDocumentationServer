//
//  home.swift
//  APIDocumentationServer
//
//  Created by Jonathan Guthrie on 2017-05-09.
//
//

import PerfectHTTP
import StORM

extension WebHandlers {

	static func home(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAccountID = request.session?.userid ?? ""
			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty

			var context: [String : Any] = ["title": "Perfect API Doc Server"]
			context["csrfToken"] = request.session?.data["csrf"] as? String ?? ""

			context["accountID"] = contextAccountID
			context["authenticated"] = contextAuthenticated


			if contextAuthenticated {
				for i in WebHandlers.extras(request) {
					context[i.0] = i.1
				}
			}
			// add app config vars
			for i in WebHandlers.appExtras(request) {
				context[i.0] = i.1
			}


			// gather list of groups and api docs to display
			let groups = APIGroup.list()
			context["groups"] = groups


			response.render(template: "views/index", context: context)
		}
	}
}
