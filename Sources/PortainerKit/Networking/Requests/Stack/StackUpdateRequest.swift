//
//  StackUpdateRequest.swift
//  PortainerKit
//
//  Created by royal on 07/05/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackUpdateRequest

struct StackUpdateRequest {
	var stackID: Stack.ID
	var endpointID: Endpoint.ID

	var settings: StackUpdateSettings
}

// MARK: - StackUpdateRequest+NetworkRequest

extension StackUpdateRequest: NetworkRequest {
	typealias ResponseBody = Stack

	var method: HTTPMethod { .put }
	var path: String { "/api/stacks/\(stackID)" }

	var queryItems: [URLQueryItem]? {
		[
			.init(name: "endpointId", value: endpointID.description)
		]
	}
}

// MARK: - StackUpdateRequest+NetworkRequestWithBody

extension StackUpdateRequest: NetworkRequestWithBody {
	typealias RequestBody = StackUpdateSettings

	var requestBody: RequestBody {
		settings
	}
}
