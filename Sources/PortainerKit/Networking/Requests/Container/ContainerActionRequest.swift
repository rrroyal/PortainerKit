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
	var signal: String?
}

// MARK: - ContainerActionRequest+NetworkRequest

extension ContainerActionRequest: NetworkRequest {
	typealias DecodedResponse = Never?

	var method: HTTPMethod { .post }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/\(action.rawValue)" }

	func makeQueryItems() throws -> [URLQueryItem]? {
		var queryItems: [URLQueryItem] = []

		if let signal {
			queryItems.append(.init(name: "signal", value: signal))
		}

		return queryItems
	}

	func handleResponse(_ response: URLResponse, data: Data) throws -> DecodedResponse {
		guard let response = response as? HTTPURLResponse else {
			throw PortainerClient.Error.invalidResponse
		}

		if response.statusCode == 204 || response.statusCode == 304 {
			// Container already has the specified state
			return nil
		} else {
			throw PortainerClient.Error.responseCodeUnacceptable(response.statusCode)
		}
	}
}
