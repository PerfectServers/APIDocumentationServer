//
//  APIGroup.swift
//  APIDocumentationServer
//
//  Created by Jonathan Guthrie on 2017-05-02.
//
//

import StORM
import PostgresStORM
import SwiftRandom
import PerfectMarkdown

public class APIGroup: PostgresStORM {
	public var id						= ""
	public var name						= ""
	public var displayOrder				= 1000
	public var objectStatus				= 1
	public var _docs					= [APIDoc]()

	let _r = URandom()

	public func makeID() {
		id = _r.secureToken
	}

	public static func runSetup() {
		do {
			let this = APIGroup()
			try this.setup()
		} catch {
			print(error)
		}
	}

	override public func to(_ this: StORMRow) {
		id					= this.data["id"] as? String			?? ""
		name				= this.data["name"] as? String			?? ""
		displayOrder		= this.data["displayorder"] as? Int		?? 1000
		objectStatus		= this.data["objectstatus"] as? Int		?? 0
		_docs				= getDocs()
	}

	public func rows() -> [APIGroup] {
		var rows = [APIGroup]()
		for i in 0..<self.results.rows.count {
			let row = APIGroup()
			row.to(self.results.rows[i])
			rows.append(row)
		}
		return rows
	}

	public static func list(_ active: Bool = true) -> [[String: Any]] {
		var list = [[String: Any]]()
		let t = APIGroup()

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
			r["name"] = row.name
			r["displayOrder"] = row.displayOrder
			if row.objectStatus == 1 {
				r["objectStatus"] = "Active"
			} else {
				r["objectStatus"] = "Inactive"
			}

			var d = [[String:Any]]()
			row._docs.forEach{
				dd in
				var s = [String:Any]()
				s["id"] = dd.id
				s["name"] = dd.name

				// Raw data for editor
				s["docdataraw"] = ""
				s["usagedataraw"] = ""

				// HTML processed for display
				s["docdata"] = ""
				s["usagedata"] = ""

				if let doc = dd.detail["docs"], !(doc as? String ?? "").isEmpty {
					s["docdataraw"] = (doc as? String ?? "")
					if let html = (doc as? String ?? "").markdownToHTML {
						s["docdata"] = html
					}
				}
				if let doc = dd.detail["usage"], !(doc as? String ?? "").isEmpty {
					s["usagedataraw"] = (doc as? String ?? "")
					if let html = (doc as? String ?? "").markdownToHTML {
						s["usagedata"] = html
					}
				}

				d.append(s)
			}
			r["docs"] = d


			list.append(r)
		}
		return list
	}

	public func getDocs() -> [APIDoc] {
		let d = APIDoc()
		do {
			try d.select(whereclause: "groupid = $1", params: [id], orderby: ["groupid"])
		} catch {
			print("doc group get error: \(error)")
		}
		return d.rows()
	}


	public static func listGroups() -> [[String: Any]] {
		var obj = [[String: Any]]()
		let t = APIGroup()
		let cursor = StORMCursor(limit: 9999999,offset: 0)
		try? t.select(
			columns: [],
			whereclause: "true",
			params: [],
			orderby: ["displayorder"],
			cursor: cursor
		)


		for row in t.rows() {
			var r = [String: Any]()
			r["id"] = row.id
			r["name"] = row.name
			r["displayorder"] = row.displayOrder
			if row.objectStatus == 1 { r["status"] = true } else { r["status"] = false }
			r["doccount"] = row._docs.count
			obj.append(r)
		}
		return obj
	}
}

