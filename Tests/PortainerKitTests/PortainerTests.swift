@testable import PortainerKit
import XCTest

final class PortainerTests: XCTestCase {
	// swiftlint:disable:next force_unwrapping
	let portainerClient = PortainerClient(serverURL: URL(string: "http://localhost:9443")!, token: "")
	let endpointID: Endpoint.ID = 0
	let containerID: Container.ID = ""
	let stackID: Stack.ID = 0

	func testContainerAction() async throws {
		let action = ContainerAction.stop

		do {
			try await portainerClient.executeContainerAction(action, containerID: containerID, endpointID: endpointID)
			print("[*] Action \"\(action)\" succeeded")
		} catch {
			print("[!] Action \"\(action)\" failed: \(error)")
			throw error
		}
	}

	func testContainerDetails() async throws {
		let response = try await portainerClient.fetchContainerDetails(for: containerID, endpointID: endpointID)
		print("[*] Container: \(response.name) (\(response.id))")
	}

	func testContainerLogs() async throws {
		let response = try await portainerClient.fetchContainerLogs(for: containerID, endpointID: endpointID, tail: 1)
		print("[*] Logs (\(response.split(separator: "\n").count)): \"\(response.prefix(32).trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: "\\n"))\"...")

		let responseAll = try await portainerClient.fetchContainerLogs(for: containerID, endpointID: endpointID, tail: .all)
		// swiftlint:disable:next line_length
		print("[*] Logs (all) (\(responseAll.split(separator: "\n").count)): \"\(responseAll.prefix(32).trimmingCharacters(in: .whitespacesAndNewlines).replacing("\n", with: "\\n"))\"...")
	}

	func testContainers() async throws {
		let filters = FetchFilters(
			name: nil
		)
		let response = try await portainerClient.fetchContainers(endpointID: endpointID, filters: filters)
		print("[*] Containers (\(response.count)): \(response.map { "\($0.names?.first ?? "nil") (\($0.id))" })")
	}

	func testEndpoints() async throws {
		let response = try await portainerClient.fetchEndpoints()
		print("[*] Endpoints (\(response.count)): \(response.map { $0.name ?? "nil" })")
	}

	func testPortainerStatus() async throws {
		let response = try await portainerClient.fetchPortainerStatus()
		print("[*] Portainer status: \(response)")
	}

	func testStackAction() async throws {
		let started = true

		do {
			let stack = try await portainerClient.setStackStatus(stackID: stackID, started: started, endpointID: endpointID)
			print("[*] Action \"\(started)\" succeeded: \(String(describing: stack))")
		} catch {
			print("[!] Action \"\(started)\" failed: \(error)")
			throw error
		}
	}

	func testStackDetails() async throws {
		let response = try await portainerClient.fetchStackDetails(stackID: stackID)
		print("[*] Stack: \(response.name) (\(response.id))")
	}

	func testStacks() async throws {
		let response = try await portainerClient.fetchStacks()
		print("[*] Stacks (\(response.count)): \(response.map { "\($0.name) (\($0.id))" })")
	}
}
