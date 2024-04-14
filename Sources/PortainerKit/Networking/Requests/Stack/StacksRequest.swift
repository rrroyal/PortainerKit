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
	typealias DecodedResponse = [Stack]

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks" }

	func makeQueryItems() throws -> [URLQueryItem]? {
		let filters = FetchFilters(
			endpointID: endpointID,
			includeOrphanedStacks: includeOrphanedStacks
		)

		let filtersEncoded = try JSONEncoder.portainer.encode(filters)
		guard let filtersQuery = String(data: filtersEncoded, encoding: .utf8) else {
			throw PortainerClient.Error.encodingFailed
		}

		return [.init(name: "filters", value: filtersQuery)]
	}
}
