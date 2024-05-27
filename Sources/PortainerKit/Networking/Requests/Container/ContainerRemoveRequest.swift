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

	func handleResponse(_ response: URLResponse, data: Data) throws -> ResponseBody {
		guard let response = response as? HTTPURLResponse else {
			throw PortainerClient.Error.invalidResponse
		}

		if (200..<400) ~= response.statusCode {
			return nil
		} else {
			let _: Never? = try PortainerClient.handleResponse(response, data: data)
			throw PortainerClient.Error.responseCodeUnacceptable(response.statusCode)
		}
	}
}
