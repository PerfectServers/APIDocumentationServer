//
//  Handlers.swift
//  Perfect-OAuth2-Server
//
//  Created by Jonathan Guthrie on 2017-04-25.
//
//
import PerfectHTTP
import StORM

class WebHandlers {

	static func extras(_ request: HTTPRequest) -> [String : Any] {

		return [
			"token": request.session?.token ?? "",
			"csrfToken": request.session?.data["csrf"] as? String ?? ""
		]

	}

	static func appExtras(_ request: HTTPRequest) -> [String : Any] {

		return [
			"configTitle": configTitle,
			"configLogo": configLogo,
			"configLogoSrcSet": configLogoSrcSet
		]

	}


	static func errorJSON(_ request: HTTPRequest, _ response: HTTPResponse, msg: String) {
		_ = try? response.setBody(json: ["error": msg])
		response.completed()
	}

	static func redirectRequest(_ request: HTTPRequest, _ response: HTTPResponse, msg: String, template: String, additional: [String:String] = [String:String]()) {
		let contextAccountID = request.session?.userid ?? ""
		let contextAuthenticated = !(request.session?.userid ?? "").isEmpty

		var context: [String : Any] = [
			"accountID": contextAccountID,
			"authenticated": contextAuthenticated,
			"msg": msg
		]

		context["csrfToken"] = request.session?.data["csrf"] as? String ?? ""

		if contextAuthenticated {
			for i in WebHandlers.extras(request) {
				context[i.0] = i.1
			}
		}
		for i in additional {
			context[i.0] = i.1
		}


		response.render(template: template, context: context)
		response.completed()
		return
	}


}
