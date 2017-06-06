//
//  docSave.swift
//  APIDocumentationServer
//
//  Created by Jonathan Guthrie on 2017-06-03.
//
//

import SwiftMoment
import PerfectHTTP
import PerfectMarkdown
import SwiftString


extension WebHandlers {

	static func docSaveDoc(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty
			if !contextAuthenticated {
				response.completed(status: .unauthorized)
				return
			}

			let obj = APIDoc()
			var msg = ""
			var md = ""

			if let body = request.postBodyString {
				do {
					let bodyData = try body.jsonDecode() as? [String: Any] ?? [String: Any]()

					if let name = bodyData["name"], !(name as? String ?? "").isEmpty,
						let id = bodyData["id"], !(id as? String ?? "").isEmpty,
						let docs = bodyData["docs"] {

						try obj.get(id)

						obj.name = name as? String ?? ""
						obj.detail["docs"] = docs as? String ?? ""

						try? obj.save()
						msg = "complete"

						md = (obj.detail["docs"] as? String ?? "").markdownToHTML ?? ""
					}
				} catch {
					msg = "\(error)"
				}
			} else {
				msg = "Name, id and doc content are all required."
			}

			_ = try? response.setBody(json: ["error":msg, "list": APIGroup.list(), "name": obj.name, "docs": md])
			response.completed()

		}
	}

	static func docSaveUsage(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			let contextAuthenticated = !(request.session?.userid ?? "").isEmpty
			if !contextAuthenticated {
				response.completed(status: .unauthorized)
				return
			}

			let obj = APIDoc()
			var msg = ""
			var md = ""

			if let body = request.postBodyString {
				do {
					let bodyData = try body.jsonDecode() as? [String: Any] ?? [String: Any]()

					if let id = bodyData["id"], !(id as? String ?? "").isEmpty,
						let usage = bodyData["usage"] {
						var u = usage as? String ?? ""

						try obj.get(id)

						// fix for missing \n
						if !u.endsWith("\n"), !u.isEmpty {
							u += "\n"
						}

						obj.detail["usage"] = u

						try? obj.save()
						msg = "complete"

						md = (obj.detail["usage"] as? String ?? "").markdownToHTML ?? ""

					}
				} catch {
					msg = "\(error)"
				}
			} else {
				msg = "Name, id and doc content are all required."
			}

			_ = try? response.setBody(json: ["error":msg, "list": APIGroup.list(), "usage": md])
			response.completed()
			
		}
	}

}
