import Foundation
import PackageDescription
let package = Package(
		name: "APIDocumentationServer",
		targets: [],
		dependencies: [
			.Package(url: "https://github.com/PerfectlySoft/Perfect-LocalAuthentication-PostgreSQL.git", majorVersion: 3),
			.Package(url: "https://github.com/PerfectlySoft/Perfect-Markdown.git", majorVersion: 3),
		]
)
