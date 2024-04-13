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

		if let queryItems = try self.queryItems(), !queryItems.isEmpty {
			url.append(queryItems: queryItems)
		}

		var request = URLRequest(url: url)
		request.httpMethod = self.method.rawValue

		if let body = try self.body() {
			request.httpBody = body
		}

		return request
	}
}
