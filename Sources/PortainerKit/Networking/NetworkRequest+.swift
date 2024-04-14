//
//  NetworkRequest+.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - NetworkRequest+Default

extension NetworkRequest {
	func handleResponse(_ response: URLResponse, data: Data) throws -> DecodedResponse {
		try PortainerClient.handleResponse(response, data: data)
	}
}

// MARK: - NetworkRequest+urlRequest

extension NetworkRequest {
	func urlRequest(baseURL: URL) throws -> URLRequest {
		var url = baseURL.appending(path: self.path)

		if let queryItems = try self.makeQueryItems(), !queryItems.isEmpty {
			url.append(queryItems: queryItems)
		}

		var request = URLRequest(url: url)
		request.httpMethod = self.method.rawValue

		if let body = try self.makeBody() {
			request.httpBody = body
		} else if let self = self as? any JSONNetworkRequest, let body = self.jsonBody {
			request.httpBody = try JSONEncoder.portainer.encode(body)
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		return request
	}
}
