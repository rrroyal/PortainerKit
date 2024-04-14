//
//  StackRemoveRequest.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackRemoveRequest

struct StackRemoveRequest {
	var stackID: Stack.ID
	var endpointID: Endpoint.ID
	var external: Bool?
}

// MARK: - StackRemoveRequest+NetworkRequest

extension StackRemoveRequest: NetworkRequest {
	typealias DecodedResponse = Never?

	var method: HTTPMethod { .delete }
	var path: String { "/api/stacks/\(stackID)" }

	func makeQueryItems() throws -> [URLQueryItem]? {
		var queryItems: [URLQueryItem] = [
			.init(name: "endpointId", value: endpointID.description)
		]

		if let external {
			queryItems.append(.init(name: "external", value: external.description))
		}

		return queryItems
	}

	func handleResponse(_ response: URLResponse, data: Data) throws -> DecodedResponse {
		guard let response = response as? HTTPURLResponse else {
			throw PortainerClient.Error.invalidResponse
		}

		if response.statusCode == 204 || response.statusCode == 304 {
			return nil
		} else {
			throw PortainerClient.Error.responseCodeUnacceptable(response.statusCode)
		}
	}
}
