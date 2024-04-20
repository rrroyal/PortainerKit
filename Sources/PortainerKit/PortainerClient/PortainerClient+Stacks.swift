//
//  PortainerClient+Stacks.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension PortainerClient {
	/// Lists all stacks based on the current user authorizations.
	/// Will return all stacks if using an administrator account otherwise it will only return the list of stacks the user have access to.
	/// - Parameters:
	///   - endpointID: Fetch stacks for this endpoint ID
	///   - includeOrphaned: Include orphaned stacks?
	/// - Returns: `[Stack]` list
	@Sendable
	func fetchStacks(endpointID: Endpoint.ID? = nil, includeOrphaned: Bool = true) async throws -> [Stack] {
		let request = StacksRequest(endpointID: endpointID, includeOrphanedStacks: includeOrphaned)
		let response = try await send(request)
		return response
	}

	/// Fetches the details for specified stack ID.
	/// - Parameter stackID: Stack ID to fetch the details for
	/// - Returns: `Stack` details
	@Sendable
	func fetchStackDetails(stackID: Stack.ID) async throws -> Stack {
		let request = StackDetailsRequest(stackID: stackID)
		let response = try await send(request)
		return response
	}

	/// Starts a stopped Stack or stops a stopped Stack.
	/// - Parameters:
	///   - stackID: Stack identifier
	///   - started: Should stack be started?
	///   - endpointID: Endpoint identifier
	/// - Returns: Affected `Stack`, or nil if not modified
	@Sendable
	func setStackState(stackID: Stack.ID, started: Bool, endpointID: Endpoint.ID) async throws -> Stack? {
		let request = StackSetStateRequest(stackID: stackID, started: started, endpointID: endpointID)
		let response = try await send(request)
		return response
	}

	/// Fetches the Docker Compose file contents for specified stack ID.
	/// - Parameter stackID: Stack ID to fetch the Docker Compose file contents for
	/// - Returns: Docker Compose file contents
	@Sendable
	func fetchStackFile(stackID: Stack.ID) async throws -> String {
		let request = StackFileRequest(stackID: stackID)
		let response = try await send(request)
		return response
	}

	/// Deploys a new stack to endpoint with specified `endpointID` with provided `settings`.
	/// - Parameters:
	///   - endpointID: Endpoint identifier
	///   - settings: Deployment settings
	/// - Returns: Newly created `Stack`
	@Sendable
	func deployStack(endpointID: Endpoint.ID, settings: some StackDeploymentSettings) async throws -> Stack {
		let request = StackDeployRequest(endpointID: endpointID, settings: settings)
		let response = try await send(request)
		return response
	}

	/// Removes a stack with specified `stackID`.
	/// - Parameters:
	///   - stackID: Stack ID to remove
	///   - endpointID: Endpoint identifier
	///   - external: Is this stack external?
	@Sendable
	func removeStack(stackID: Stack.ID, endpointID: Endpoint.ID, external: Bool = false) async throws {
		let request = StackRemoveRequest(stackID: stackID, endpointID: endpointID, external: external)
		_ = try await send(request)
	}
}
