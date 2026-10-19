//
//  ContainerActionRequest.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainerActionRequest

struct ContainerActionRequest {
	var containerID: Container.ID
	var endpointID: Endpoint.ID
	var action: ContainerAction
}

// MARK: - ContainerActionRequest+NetworkRequest

extension ContainerActionRequest: NetworkRequest {
	typealias ResponseBody = Never?

	var method: HTTPMethod { .post }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/\(action.rawValue)" }
}
