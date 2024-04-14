//
//  StackDeployRequest.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackDeployRequest

struct StackDeployRequest<Settings: StackDeploymentSettings> {
	var endpointID: Endpoint.ID
	var settings: Settings
}

// MARK: - StackDeployRequest+NetworkRequest

extension StackDeployRequest: NetworkRequest {
	typealias DecodedResponse = Stack

	var method: HTTPMethod { .post }
	var path: String { "/api/stacks/create/\(settings.deploymentType.rawValue)/\(settings.deploymentMethod.rawValue)" }

	func makeQueryItems() throws -> [URLQueryItem]? {
		[
			.init(name: "endpointId", value: endpointID.description)
		]
	}
}

// MARK: - StackDeployRequest+JSONNetworkRequest

extension StackDeployRequest: JSONNetworkRequest {
	typealias JSONBody = Settings

	var jsonBody: JSONBody? { settings }
}
