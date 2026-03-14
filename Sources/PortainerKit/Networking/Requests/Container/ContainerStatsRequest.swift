//
//  ContainerStatsRequest.swift
//  PortainerKit
//
//  Created by royal on 14/03/2026.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainerStatsRequest

struct ContainerStatsRequest {
	var containerID: Container.ID
	var endpointID: Endpoint.ID
}

// MARK: - ContainerStatsRequest+NetworkRequest

extension ContainerStatsRequest: NetworkRequest {
	typealias ResponseBody = ContainerStats

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/stats" }
	var queryItems: [URLQueryItem]? { [.init(name: "stream", value: "false")] }
}
