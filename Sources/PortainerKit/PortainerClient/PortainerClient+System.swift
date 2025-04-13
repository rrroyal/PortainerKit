//
//  PortainerClient+System.swift
//  PortainerKit
//
//  Created by royal on 13/04/2025.
//  Copyright © 2025 shameful. All rights reserved.
//

public extension PortainerClient {
	/// Retrieve Portainer status.
	/// - Returns: `SystemStatus`
	func fetchSystemStatus() async throws -> SystemStatus {
		let request = SystemStatusRequest()
		let response = try await send(request)
		return response
	}
}
