//
//  userModAction.swift
//  APIDocumentationServer
//
//  Created by Jonathan Guthrie on 2017-05-02.
//
//

import SwiftMoment
import PerfectHTTP


extension WebHandlers {

	static func docCreate(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty
			if !contextAuthenticated {
				response.completed(status: .unauthorized)
				return
			}

			let obj = APIDoc()
			var msg = ""

			if let body = request.postBodyString {
				do {
					let bodyData = try body.jsonDecode() as? [String: Any] ?? [String: Any]()

					if let name = bodyData["name"], !(name as? String ?? "").isEmpty,
						let groupid = bodyData["groupid"], !(groupid as? String ?? "").isEmpty {
						obj.name = name as? String ?? ""
						obj.groupid = groupid as? String ?? ""
						obj.makeID()
						try? obj.create()
						msg = "complete"
					}
				} catch {
					msg = "\(error)"
				}
			} else {
				msg = "A name is required."
			}

			_ = try? response.setBody(json: ["error":msg, "list": APIGroup.list()])
			response.completed()


		}
	}
}
