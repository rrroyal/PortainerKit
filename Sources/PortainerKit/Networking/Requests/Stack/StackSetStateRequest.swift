//
//  StackSetStateRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackSetStateRequest

struct StackSetStateRequest {
	var stackID: Stack.ID
	var started: Bool
	var endpointID: Endpoint.ID
}

// MARK: - StackSetStateRequest+NetworkRequest

extension StackSetStateRequest: NetworkRequest {
	typealias ResponseBody = Stack

	var method: HTTPMethod { .post }
	var path: String { "/api/stacks/\(stackID)/\(started ? "start" : "stop")" }

	var queryItems: [URLQueryItem]? {
		[
			.init(name: "endpointId", value: "\(endpointID)")
		]
	}
}
