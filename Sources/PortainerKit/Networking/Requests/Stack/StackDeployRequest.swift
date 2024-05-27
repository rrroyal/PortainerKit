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
	typealias ResponseBody = Stack

	var method: HTTPMethod { .post }
	var path: String { "/api/stacks/create/\(settings.deploymentType.rawValue)/\(settings.deploymentMethod.rawValue)" }

	var queryItems: [URLQueryItem]? {
		[
			.init(name: "endpointId", value: endpointID.description)
		]
	}
}

// MARK: - StackDeployRequest+NetworkRequestWithBody

extension StackDeployRequest: NetworkRequestWithBody {
	typealias RequestBody = Settings

	var requestBody: RequestBody {
		settings
	}
}
