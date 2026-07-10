//
//  StackDecodingTests.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

import Foundation
@testable import PortainerKit
import Testing

// MARK: - StackDecodingTests

/// Tests that ``PortainerClient``'s stack endpoints correctly decode real-shaped Portainer API payloads.
@Suite(.tags(.networking, .decoding, .stacks))
struct StackDecodingTests {
	private typealias Support = DecodingTestSupport

	@Test("Decodes a list of stacks from a real /stacks payload")
	func decodeStacks() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("stacks")))

		let stacks = try await client.fetchStacks(endpointID: Support.endpointID, includeOrphaned: true)

		#expect(stacks.count == 3)

		let media = try #require(stacks.first { $0.id == 1 })
		#expect(media.name == "media")
		#expect(media.type == .dockerCompose)
		#expect(media.status == .active)
		#expect(media.gitConfig?.referenceName == "refs/heads/main")
		#expect(media.autoUpdate?.forcePullImage == true)
		#expect(media.env?.contains(.init(name: "PUID", value: "1000")) == true)

		let swarm = try #require(stacks.first { $0.id == 2 })
		#expect(swarm.type == .swarm)

		let inactive = try #require(stacks.first { $0.id == 3 })
		#expect(inactive.status == .inactive)
	}

	@Test("Decodes a single stack from a real /stacks/{id} payload")
	func decodeStack() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("stack")))

		let stack = try await client.fetchStack(id: Support.stackID)

		#expect(stack.name == "media")
		#expect(stack.endpointID == Support.endpointID)
		#expect(stack.creationDate == Date(timeIntervalSince1970: 1_716_900_000))
		#expect(stack.createdBy == "admin")
	}
}
