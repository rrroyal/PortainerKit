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
	typealias ResponseBody = Never?

	var method: HTTPMethod { .delete }
	var path: String { "/api/stacks/\(stackID)" }

	var queryItems: [URLQueryItem]? {
		var queryItems: [URLQueryItem] = [
			.init(name: "endpointId", value: endpointID.description)
		]

		if let external {
			queryItems.append(.init(name: "external", value: external.description))
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
