//
//  EndpointDecodingTests.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

@testable import PortainerKit
import Testing

// MARK: - EndpointDecodingTests

/// Tests that ``PortainerClient``'s environment (endpoint) endpoints correctly decode real-shaped Portainer API payloads.
@Suite(.tags(.networking, .decoding, .endpoints))
struct EndpointDecodingTests {
	private typealias Support = DecodingTestSupport

	@Test("Decodes a list of environments from a real /endpoints payload")
	func decodeEndpoints() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("endpoints")))

		let endpoints = try await client.fetchEndpoints()

		#expect(endpoints.count == 2)

		let local = try #require(endpoints.first { $0.id == 1 })
		#expect(local.name == "local")
		#expect(local.status == .up)
		#expect(local.tags == ["prod", "docker"])
		#expect(local.tagIDs == [1, 2])

		let remote = try #require(endpoints.first { $0.id == 2 })
		#expect(remote.name == "remote-nas")
		#expect(remote.status == .down)
	}
}
