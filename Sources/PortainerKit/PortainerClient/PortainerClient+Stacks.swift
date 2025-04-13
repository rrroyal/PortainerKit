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
	func fetchStacks(endpointID: Endpoint.ID?, includeOrphaned: Bool) async throws -> [Stack] {
		let request = StacksRequest(endpointID: endpointID, includeOrphanedStacks: includeOrphaned)
		let response = try await send(request)
		return response
	}

	/// Fetches the stack with specified ID.
	/// - Parameter stackID: Stack ID
	/// - Returns: `Stack`
	func fetchStack(id stackID: Stack.ID) async throws -> Stack {
		let request = StackRequest(stackID: stackID)
		let response = try await send(request)
		return response
	}

	/// Starts a stopped Stack or stops a stopped Stack.
	/// - Parameters:
	///   - stackID: Stack identifier
	///   - started: Should stack be started?
	///   - endpointID: Endpoint identifier
	/// - Returns: Affected `Stack`, or nil if not modified
	func setStackState(stackID: Stack.ID, started: Bool, endpointID: Endpoint.ID) async throws -> Stack? {
		let request = StackSetStateRequest(stackID: stackID, started: started, endpointID: endpointID)
		let response = try await send(request)
		return response
	}

	/// Fetches the Docker Compose file contents for specified stack ID.
	/// - Parameter stackID: Stack ID to fetch the Docker Compose file contents for
	/// - Returns: Docker Compose file contents
	func fetchStackFile(stackID: Stack.ID) async throws -> String {
		let request = StackFileRequest(stackID: stackID)
		let response = try await send(request)
		return response.stackFileContent
	}

	/// Deploys a new stack to endpoint with specified `endpointID` with provided `settings`.
	/// - Parameters:
	///   - endpointID: Endpoint identifier
	///   - settings: Deployment settings
	/// - Returns: Newly created `Stack`
	func deployStack(endpointID: Endpoint.ID, settings: some StackDeploymentSettings) async throws -> Stack {
		let request = StackDeployRequest(endpointID: endpointID, settings: settings)
		let response = try await send(request)
		return response
	}

	/// Updates a stack with specified `stackID` and  `endpointID` with provided `settings`.
	/// - Parameters:
	///   - stackID: Stack identifier
	///   - endpointID: Endpoint identifier
	///   - settings: Update settings
	/// - Returns: Updated `Stack`
	func updateStack(stackID: Stack.ID, endpointID: Endpoint.ID, settings: StackUpdateSettings) async throws -> Stack {
		let request = StackUpdateRequest(stackID: stackID, endpointID: endpointID, settings: settings)
		let response = try await send(request)
		return response
	}

	/// Removes a stack with specified `stackID`.
	/// - Parameters:
	///   - stackID: Stack ID to remove
	///   - endpointID: Endpoint identifier
	///   - external: Is this stack external?
	func removeStack(stackID: Stack.ID, endpointID: Endpoint.ID, external: Bool = false) async throws {
		let request = StackRemoveRequest(stackID: stackID, endpointID: endpointID, external: external)
		_ = try await send(request)
	}
}
