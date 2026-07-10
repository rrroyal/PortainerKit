//
//  ContainerDecodingTests.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

import Foundation
@testable import PortainerKit
import Testing

// MARK: - ContainerDecodingTests

/// Tests that ``PortainerClient``'s container endpoints correctly decode real-shaped Docker Engine API payloads.
@Suite(.tags(.networking, .decoding, .containers))
struct ContainerDecodingTests {
	private typealias Support = DecodingTestSupport

	@Test("Decodes a list of containers from a real Docker /containers/json payload")
	func decodeContainers() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("containers")))

		let containers = try await client.fetchContainers(endpointID: Support.endpointID)

		#expect(containers.count == 3)

		let plex = try #require(containers.first { $0.id == Support.containerID })
		#expect(plex.names == ["/plex"])
		#expect(plex.image == "linuxserver/plex:latest")
		#expect(plex.state == .running)
		#expect(plex.status == "Up 3 days")
		#expect(plex.labels?["com.docker.compose.project"] == "media")
		#expect(plex.ports?.first?.privatePort == 32400)
		#expect(plex.mounts?.count == 2)

		let restarting = try #require(containers.first { $0.names == ["/postgres"] })
		#expect(restarting.state == .restarting)

		let exited = try #require(containers.first { $0.names == ["/old_cache"] })
		#expect(exited.state == .exited)
	}

	@Test("Decodes low-level container details from a real Docker inspect payload")
	func decodeContainerDetails() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("container_details")))

		let details = try await client.fetchContainerDetails(for: Support.containerID, endpointID: Support.endpointID)

		#expect(details.id == Support.containerID)
		#expect(details.name == "/plex")
		#expect(details.state.running)
		#expect(details.state.state == .running)
		#expect(details.state.health?.status == "healthy")
		#expect(details.config?.hostname == "plex")
		#expect(details.config?.env.contains("PUID=1000") == true)
		#expect(details.networkSettings.networks?["media_default"]?.ipAddress == "172.20.0.5")
		#expect(details.mounts.count == 2)
		#expect(details.hostConfig.devices?.first?.pathOnHost == "/dev/dri")
		#expect(details.hostConfig.portBindings?["32400/tcp"]?.first?.hostPort == "32400")
	}

	@Test("Throws a decoding error when the container details response doesn't match the expected shape")
	func decodeMalformedContainerThrows() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("malformed_container")))

		do {
			_ = try await client.fetchContainerDetails(for: Support.containerID, endpointID: Support.endpointID)
			Issue.record("Expected fetchContainerDetails to throw for a malformed payload, but it succeeded.")
		} catch is DecodingError {
			// Expected: the malformed fixture is missing required fields for `ContainerDetails`.
		} catch is DateError {
			// Expected: the malformed fixture's `Created` value isn't a parseable date or timestamp.
		} catch {
			Issue.record("Expected a DecodingError or DateError, but got \(error) instead.")
		}
	}

	@Test("Sends the expected request path and X-API-Key header when fetching containers")
	func fetchContainersSendsExpectedRequest() async throws {
		let (client, session) = try Support.makeClient(token: "test-token-123")
		await session.setBehavior(.respond(data: try Support.fixture("containers")))

		_ = try await client.fetchContainers(endpointID: Support.endpointID)

		let request = try #require(await session.lastRequest)
		#expect(request.url?.path == "/api/endpoints/\(Support.endpointID)/docker/containers/json")
		#expect(request.httpMethod == "GET")
		#expect(request.value(forHTTPHeaderField: "X-API-Key") == "test-token-123")
	}
}
