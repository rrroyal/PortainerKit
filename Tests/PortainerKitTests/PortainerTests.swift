@testable import PortainerKit
import XCTest

final class PortainerTests: XCTestCase {
	// swiftlint:disable:next force_unwrapping
	let portainerClient = PortainerClient(serverURL: URL(string: "https://localhost:9443/portainer")!, token: "")
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
		print("[*] Container: \"\(response.name)\" (\(response.id))")
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

	func testStackAction() async throws {
		let started = true

		do {
			let stack = try await portainerClient.setStackState(stackID: stackID, started: started, endpointID: endpointID)
			print("[*] Action \"\(started)\" succeeded: \(String(describing: stack))")
		} catch {
			print("[!] Action \"\(started)\" failed: \(error)")
			throw error
		}
	}

	func testStackDetails() async throws {
		let response = try await portainerClient.fetchStackDetails(stackID: stackID)
		print("[*] Stack: \"\(response.name)\" (\(response.id))")
	}

	func testStackDeployment() async throws {
		let containerName = "plex2"
		// swiftlint:disable all
		let stackFileContent = """
version: "3.9"
services:
  \(containerName):
    image: "linuxserver/plex:latest"
    container_name: "\(containerName)"
    network_mode: host
    restart: unless-stopped
    labels:
      xyz.shameful.harbour.association_id: "\(containerName)"
""".trimmingCharacters(in: .whitespacesAndNewlines).replacing("\t", with: "  ")
		// swiftlint:enable all
		let settings = StackDeployment.DeploymentSettings.StandaloneString(
			name: "test_plex",
			stackFileContent: stackFileContent
		)
		let response = try await portainerClient.deployStack(endpointID: endpointID, settings: settings)
		print("[*] Stack Deployment: \"\(response.name)\" (\(response.id))")
	}

	func testStackSetState() async throws {
		let started = true

		do {
			print("[*] Setting the state: \(started) for the stack with ID: \"\(stackID)\"")
			_ = try await portainerClient.setStackState(stackID: stackID, started: started, endpointID: endpointID)
		} catch {
			print("[!] Failed to set the state for the stack with ID: \"\(stackID)\": \(error)")
			throw error
		}
	}

	func testStackRemove() async throws {
		do {
			try await portainerClient.removeStack(stackID: stackID, endpointID: endpointID)
			print("[*] Removed stack with ID: \"\(stackID)\"")
		} catch {
			print("[!] Failed to remove stack with ID: \"\(stackID)\": \(error)")
			throw error
		}
	}

	func testStacks() async throws {
		let response = try await portainerClient.fetchStacks()
		print("[*] Stacks (\(response.count)): \(response.map { "\($0.name) (\($0.id))" })")
	}
}
