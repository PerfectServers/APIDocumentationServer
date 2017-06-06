//
//  userDelete.swift
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

	static func groupDelete(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			if (request.session?.userid ?? "").isEmpty { response.completed(status: .notAcceptable) }

			let obj = APIGroup()

			if let id = request.urlVariables["id"] {
				try? obj.get(id)

				let gCount = APIGroup()
				try? gCount.findAll()
				if gCount.results.cursorData.totalRecords <= 1 {
					errorJSON(request, response, msg: "You cannot delete the last group.")
					return
				}

				if obj.id.isEmpty {
					errorJSON(request, response, msg: "Invalid Group")
				} else {
					do {
						// delete nested docs
						try obj._docs.forEach{
							doc in
							try doc.delete()
						}
						try obj.delete()
					} catch {
						print(error)
					}

				}
			}


			response.setHeader(.contentType, value: "application/json")
			var resp = [String: Any]()
			resp["error"] = "None"
			do {
				try response.setBody(json: resp)
			} catch {
				print("error setBody: \(error)")
			}
			response.completed()
			return
		}
	}
}
