//
//  SystemDecodingTests.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

@testable import PortainerKit
import Testing

// MARK: - SystemDecodingTests

/// Tests that ``PortainerClient``'s system endpoints correctly decode real-shaped Portainer API payloads.
@Suite(.tags(.networking, .decoding, .system))
struct SystemDecodingTests {
	private typealias Support = DecodingTestSupport

	@Test("Decodes system status from a real /system/status payload")
	func decodeSystemStatus() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("system_status")))

		let status = try await client.fetchSystemStatus()

		#expect(status.version == "2.19.4")
		#expect(status.instanceID == "8f3a1e2b-9c4d-5f6a-7b8c-9d0e1f2a3b4c")
	}

	@Test("Decodes system version from a real /system/version payload")
	func decodeSystemVersion() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("system_version")))

		let version = try await client.fetchSystemVersion()

		#expect(version.serverEdition == "CE")
		#expect(version.updateAvailable)
		#expect(version.build?.gitCommit == "a1b2c3d4")
	}
}
