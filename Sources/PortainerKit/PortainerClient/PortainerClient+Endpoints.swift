//
//  PortainerClient+Endpoints.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

public extension PortainerClient {
	/// Lists all environments(endpoints) based on the current user authorizations.
	/// Will return all environments(endpoints) if using an administrator or team leader account.
	/// Otherwise it will only return authorized environments(endpoints).
	///
	/// - Returns: `[Endpoint]`
	@Sendable
	func fetchEndpoints() async throws -> [Endpoint] {
		let request = EndpointsRequest()
		let response = try await send(request)
		return response
	}
}
