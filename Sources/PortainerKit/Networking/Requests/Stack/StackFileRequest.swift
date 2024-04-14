//
//  StackFileRequest.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - StackFileRequest

struct StackFileRequest {
	var stackID: Stack.ID
}

// MARK: - StackFileRequest+NetworkRequest

extension StackFileRequest: NetworkRequest {
	typealias DecodedResponse = String

	var method: HTTPMethod { .get }
	var path: String { "/api/stacks/\(stackID)/file" }

	func handleResponse(_ response: URLResponse, data: Data) throws -> DecodedResponse {
		let decoded: ResponseBody = try PortainerClient.handleResponse(response, data: data)
		return decoded.stackFileContent
	}
}

// MARK: - StackFileRequest+ResponseBody

extension StackFileRequest {
	struct ResponseBody: Decodable {
		enum CodingKeys: String, CodingKey {
			case stackFileContent = "StackFileContent"
		}

		var stackFileContent: String
	}
}
