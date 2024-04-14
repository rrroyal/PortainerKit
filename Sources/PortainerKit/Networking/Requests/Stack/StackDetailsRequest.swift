//
//  StackDetailsRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackDetailsRequest

struct StackDetailsRequest {
	var stackID: Stack.ID
}

// MARK: - StackDetailsRequest+NetworkRequest

extension StackDetailsRequest: NetworkRequest {
	typealias DecodedResponse = Stack

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks/\(stackID)" }
}
