//
//  APIDoc.swift
//  APIDocumentationServer
//
//  Created by Jonathan Guthrie on 2017-05-02.
//
//

import StORM
import PostgresStORM
import SwiftRandom

public class APIDoc: PostgresStORM {
	public var id						= ""
	public var groupid					= ""
	public var name						= ""
	public var displayOrder				= 1000
	public var detail					= [String:Any]()
	public var objectStatus				= 1

	let _r = URandom()

	public func makeID() {
		id = _r.secureToken
	}

	public static func runSetup() {
		do {
			let this = APIDoc()
			try this.setup()
		} catch {
			print(error)
		}
	}

	override public func to(_ this: StORMRow) {
		id					= this.data["id"] as? String			?? ""
		groupid				= this.data["groupid"] as? String		?? ""
		name				= this.data["name"] as? String			?? ""
		displayOrder		= this.data["displayorder"] as? Int		?? 1000
		if let dataObj = this.data["detail"] { detail = (dataObj as? [String:Any])! }
		objectStatus		= this.data["objectstatus"] as? Int		?? 0
	}

	public func rows() -> [APIDoc] {
		var rows = [APIDoc]()
		for i in 0..<self.results.rows.count {
			let row = APIDoc()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}

	public static func list(_ active: Bool = true) -> [[String: Any]] {
		var list = [[String: Any]]()
		let t = APIDoc()

		var whereclause = "true"
		if active == true {
			whereclause = " objectstatus = 1 "
		}

		let cursor = StORMCursor(limit: 9999999,offset: 0)

		try? t.select(
			columns: [],
			whereclause: whereclause,
			params: [],
			orderby: ["displayorder, name"],
			cursor: cursor
		)

		for row in t.rows() {
			var r = [String: Any]()
			r["id"] = row.id
			r["groupid"] = row.groupid
			r["name"] = row.name
			r["displayOrder"] = row.displayOrder
			r["detail"] = row.detail
			if row.objectStatus == 1 {
				r["objectStatus"] = "Active"
			} else {
				r["objectStatus"] = "Inactive"
			}
			list.append(r)
		}
		return list
	}
	
	
}

