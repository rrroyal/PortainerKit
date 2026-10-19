//
//  ContainerRemoveRequest.swift
//  PortainerKit
//
//  Created by royal on 03/05/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainerRemoveRequest

struct ContainerRemoveRequest {
	var containerID: Container.ID
	var endpointID: Endpoint.ID

	var removeVolumes = false
	var force = false
}

// MARK: - ContainerRemoveRequest+NetworkRequest

extension ContainerRemoveRequest: NetworkRequest {
	typealias ResponseBody = Never?

	var method: HTTPMethod { .delete }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)" }

	var queryItems: [URLQueryItem]? {
		[
			.init(name: "v", value: removeVolumes ? "true" : "false"),
			.init(name: "force", value: force ? "true" : "false")
		]
	}
}
