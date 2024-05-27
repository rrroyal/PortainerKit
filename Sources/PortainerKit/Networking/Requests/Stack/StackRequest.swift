//
//  StackRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackRequest

struct StackRequest {
	var stackID: Stack.ID
}

// MARK: - StackRequest+NetworkRequest

extension StackRequest: NetworkRequest {
	typealias ResponseBody = Stack

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks/\(stackID)" }
}
