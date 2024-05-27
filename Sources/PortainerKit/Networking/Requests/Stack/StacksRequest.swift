//
//  StacksRequest.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StacksRequest

struct StacksRequest {
	var endpointID: Endpoint.ID?
	var includeOrphanedStacks = true
}

// MARK: - StacksRequest+NetworkRequest

extension StacksRequest: NetworkRequest {
	typealias ResponseBody = [Stack]

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks" }

	var queryItems: [URLQueryItem]? {
		get throws {
			let filters = FetchFilters(
				endpointID: endpointID,
				includeOrphanedStacks: includeOrphanedStacks
			)

			let filtersEncoded = try JSONEncoder.portainer.encode(filters)
			let filtersQuery = String(decoding: filtersEncoded, as: UTF8.self)
			return [.init(name: "filters", value: filtersQuery)]
		}
	}
}
