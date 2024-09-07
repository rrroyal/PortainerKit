// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PortainerKit",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "PortainerKit",
			targets: ["PortainerKit"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/rrroyal/NetworkKit", branch: "main")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "PortainerKit",
			dependencies: ["NetworkKit"]
		),
		.testTarget(
			name: "PortainerKitTests",
			dependencies: ["PortainerKit"]
		)
	],
	swiftLanguageModes: [
		.v6
	]
)
