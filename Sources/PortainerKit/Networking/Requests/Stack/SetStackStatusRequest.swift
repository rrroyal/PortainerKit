//
//  SetStackStatusRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - SetStackStatusRequest

struct SetStackStatusRequest {
	var stackID: Stack.ID
	var started: Bool
	var endpointID: Endpoint.ID
}

// MARK: - SetStackStatusRequest+APIRequest

extension SetStackStatusRequest: NetworkRequest {
	typealias DecodedResponse = Stack

	var method: HTTPMethod { .post }
	var path: String { "/api/stacks/\(stackID)/\(started ? "start" : "stop")" }

	func queryItems() throws -> [URLQueryItem]? {
		[.init(name: "endpointId", value: "\(endpointID)")]
	}
}
