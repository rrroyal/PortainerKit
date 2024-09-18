//
//  ContainersRequest.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainersRequest

struct ContainersRequest {
	var endpointID: Endpoint.ID

	var all = true
	var filters: FetchFilters?
}

// MARK: - ContainersRequest+NetworkRequest

extension ContainersRequest: NetworkRequest {
	typealias ResponseBody = [Container]

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/json" }

	var queryItems: [URLQueryItem]? {
		get throws {
			var queryItems: [URLQueryItem] = [
				.init(name: "all", value: "\(all ? "true" : "false")")
			]

			if let filters {
				let filtersEncoded = try JSONEncoder.portainer.encode(filters)
				guard let queryItemString = String(data: filtersEncoded, encoding: .utf8) else {
					throw PortainerClient.ClientError.encodingFailed
				}
				let queryItem = URLQueryItem(name: "filters", value: queryItemString)
				queryItems.append(queryItem)
			}

			return queryItems
		}
	}
}
