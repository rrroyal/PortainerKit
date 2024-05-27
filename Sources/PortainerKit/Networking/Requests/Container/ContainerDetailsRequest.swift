//
//  ContainerDetailsRequest.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainerDetailsRequest

struct ContainerDetailsRequest {
	var containerID: Container.ID
	var endpointID: Endpoint.ID
}

// MARK: - ContainerDetailsRequest+NetworkRequest

extension ContainerDetailsRequest: NetworkRequest {
	typealias ResponseBody = ContainerDetails

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/json" }
}
