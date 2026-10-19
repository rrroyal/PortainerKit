//
//  PortainerClient+Containers.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension PortainerClient {
	/// Returns a list of containers. For details on the format, see the inspect endpoint.
	/// - Parameter endpointID: Endpoint ID
	/// - Parameter filters: Query filters
	/// - Returns: `[Container]`
	func fetchContainers(endpointID: Endpoint.ID, filters: FetchFilters? = nil) async throws -> [Container] {
		let request = ContainersRequest(endpointID: endpointID, filters: filters)
		let response = try await send(request)
		return response.decodedValues()
	}

	/// Convenience function; fetches all of the containers belonging to the specified `stackName`.
	/// - Parameters:
	///   - endpointID: Endpoint ID
	///   - stackName: Stack name
	/// - Returns: `[Container]`
	@inlinable
	func fetchContainers(endpointID: Endpoint.ID, stackName: String) async throws -> [Container] {
		// This will probably break with Swarm projects, but it will be a problem for future me :)
		let filters = FetchFilters(
			label: ["\(ContainerLabel.stack)=\(stackName)"]
		)
		return try await fetchContainers(endpointID: endpointID, filters: filters)
	}

	/// Returns low-level information about a container.
	/// - Parameters:
	///   - containerID: Container ID
	///   - endpointID: Endpoint ID
	/// - Returns: `ContainerDetails`
	func fetchContainerDetails(for containerID: Container.ID, endpointID: Endpoint.ID) async throws -> ContainerDetails {
		let request = ContainerDetailsRequest(containerID: containerID, endpointID: endpointID)
		let response = try await send(request)
		return response
	}

	/// Executes an arbitary action on specified container.
	/// - Parameters:
	///   - action: Executed action
	///   - containerID: Container ID
	///   - endpointID: Endpoint ID
	func executeContainerAction(_ action: ContainerAction, containerID: Container.ID, endpointID: Endpoint.ID) async throws {
		let request = ContainerActionRequest(containerID: containerID, endpointID: endpointID, action: action)
		_ = try await send(request)
	}

	/// Fetches stdout and stderr logs from a container.
	/// Note: This endpoint works only for containers with the json-file or journald logging driver.
	/// - Parameters:
	///   - containerID: Container ID
	///   - endpointID: Endpoint ID
	///   - since: Fetch logs since then
	///   - amount: Number of lines, counting from the end
	///   - timestamps: Display timestamps?
	/// - Returns: Logs for specified container
	func fetchContainerLogs(
		for containerID: Container.ID,
		endpointID: Endpoint.ID,
		stderr includeStderr: Bool = true,
		stdout includeStdout: Bool = true,
		since logsSince: TimeInterval? = nil,
		tail tailAmount: LogsAmount? = nil,
		includeTimestamps: Bool? = nil
	) async throws -> String {
		let request = ContainerLogsRequest(
			containerID: containerID,
			endpointID: endpointID,
			since: logsSince,
			stderr: includeStderr,
			stdout: includeStdout,
			tailAmount: tailAmount,
			includeTimestamps: includeTimestamps
		)
		let result = try await send(request)
		return result
	}

	/// Remove a container.
	/// - Parameters:
	///   - containerID: Container ID to remove
	///   - endpointID: ID of the endpoint with specified `containerID`
	///   - removeVolumes: Remove the volumes associated with the container
	///   - force: If the container is running, kill it before removing it
	func removeContainer(
		containerID: Container.ID,
		endpointID: Endpoint.ID,
		removeVolumes: Bool = false,
		force: Bool = false
	) async throws {
		let request = ContainerRemoveRequest(containerID: containerID, endpointID: endpointID, removeVolumes: removeVolumes, force: force)
		_ = try await send(request)
	}
}
