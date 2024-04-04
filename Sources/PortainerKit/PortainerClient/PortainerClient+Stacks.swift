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
	/// - Returns: `[Stack]`
	@Sendable
	func fetchStacks() async throws -> [Stack] {
		let request = StacksRequest()
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
	func setStackStatus(stackID: Stack.ID, started: Bool, endpointID: Endpoint.ID) async throws -> Stack? {
		let request = SetStackStatusRequest(stackID: stackID, started: started, endpointID: endpointID)
		let response = try await send(request)
		return response
	}
}
