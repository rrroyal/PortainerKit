//
//  DecodingTestSupport.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

import Foundation
@testable import PortainerKit
import Testing

// MARK: - DecodingTestSupport

/// Shared helpers for building a mocked ``PortainerClient`` and loading JSON fixtures, used across the decoding test suites.
enum DecodingTestSupport {
	static let endpointID: Endpoint.ID = 1
	static let containerID: Container.ID = "8f3a1e2b9c4d5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a"
	static let stackID: Stack.ID = 1

	/// Builds a `PortainerClient` wired to a fresh `MockPortainerURLSession`.
	static func makeClient(
		serverURL: URL? = nil,
		token: String = "test-token"
	) throws -> (client: PortainerClient, session: MockPortainerURLSession) {
		let url = try serverURL ?? #require(URL(string: "https://portainer.example.com"))
		let session = MockPortainerURLSession()
		let client = PortainerClient._forTests(serverURL: url, token: token, urlSession: session)
		return (client, session)
	}

	/// Loads a JSON fixture from `Resources/` by name (without extension).
	static func fixture(_ name: String) throws -> Data {
		guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Resources") else {
			throw FixtureError.notFound(name)
		}
		return try Data(contentsOf: url)
	}

	enum FixtureError: Error, CustomStringConvertible {
		case notFound(String)

		var description: String {
			switch self {
			case .notFound(let name):
				"Fixture \"\(name).json\" not found in test bundle resources."
			}
		}
	}
}
