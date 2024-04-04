//
//  StacksRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import NetworkKit

// MARK: - StacksRequest

struct StacksRequest { }

// MARK: - StacksRequest+APIRequest

extension StacksRequest: NetworkRequest {
	typealias DecodedResponse = [Stack]

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks" }
}
