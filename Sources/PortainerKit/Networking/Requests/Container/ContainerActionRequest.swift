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

extension ContainerActionRequest: NetworkRequestWithBody {
	typealias ResponseBody = Never?

	var method: HTTPMethod { .post }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/\(action.rawValue)" }
	var requestBody: String { "{}" }

	var queryItems: [URLQueryItem]? {
		var queryItems: [URLQueryItem] = []

		if let signal {
			queryItems.append(.init(name: "signal", value: signal))
		}

		return queryItems
	}

	func handleResponse(_ response: URLResponse, data: Data) throws -> ResponseBody {
		guard let response = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}

		if (200..<400) ~= response.statusCode {
			return nil
		} else {
			let _: Never? = try PortainerClient.handleResponse(response, data: data)
			throw PortainerClient.ClientError.responseCodeUnacceptable(response.statusCode)
		}
	}
}
