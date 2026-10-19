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
	func handleResponse(_ response: URLResponse, data: Data) throws -> ResponseBody {
		try PortainerClient.handleResponse(response, data: data)
	}
}

// MARK: - NetworkRequest+Empty

extension NetworkRequest where ResponseBody == Never? {
	func handleResponse(_ response: URLResponse, data: Data) throws -> ResponseBody {
		guard let response = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}

		// 304 - container is already in the requested state.
		if (200..<300) ~= response.statusCode || response.statusCode == 304 {
			return nil
		} else {
			let _: Never? = try PortainerClient.handleResponse(response, data: data)
			throw PortainerClient.ClientError.responseCodeUnacceptable(response.statusCode)
		}
	}
}

// MARK: - NetworkRequest+urlRequest

extension NetworkRequest {
	func urlRequest(baseURL: URL) throws -> URLRequest {
		var url = baseURL.appending(path: self.path)

		if let queryItems = try self.queryItems, !queryItems.isEmpty {
			url.append(queryItems: queryItems)
		}

		var request = URLRequest(url: url)
		request.httpMethod = self.method.rawValue

		if let self = self as? any NetworkRequestWithBody {
			request.httpBody = try JSONEncoder.portainer.encode(try self.requestBody)
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		return request
	}
}
