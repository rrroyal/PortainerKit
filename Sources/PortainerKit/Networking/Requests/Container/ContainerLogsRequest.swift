//
//  ContainerLogsRequest.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit

// MARK: - ContainerLogsRequest

struct ContainerLogsRequest {
	var containerID: Container.ID
	var endpointID: Endpoint.ID

	var since: TimeInterval?
	var stderr: Bool?
	var stdout: Bool?
	var tailAmount: LogsAmount?
	var includeTimestamps: Bool?

	init(
		containerID: Container.ID,
		endpointID: Endpoint.ID,
		since: TimeInterval? = nil,
		stderr: Bool? = nil,
		stdout: Bool? = nil,
		tailAmount: LogsAmount? = nil,
		includeTimestamps: Bool? = nil
	) {
		self.containerID = containerID
		self.endpointID = endpointID
		self.since = since
		self.stderr = stderr
		self.stdout = stdout
		self.tailAmount = tailAmount
		self.includeTimestamps = includeTimestamps
	}
}

// MARK: - ContainerLogsRequest+NetworkRequest

extension ContainerLogsRequest: NetworkRequest {
	typealias DecodedResponse = String

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/logs" }

	func queryItems() throws -> [URLQueryItem]? {
		var queryItems: [URLQueryItem] = [
			.init(name: "stderr", value: (stderr ?? false) ? "1" : "0"),
			.init(name: "stdout", value: (stdout ?? false) ? "1" : "0")
		]

		if let since { queryItems.append(.init(name: "since", value: "\(Int(since))")) }
		if let includeTimestamps { queryItems.append(.init(name: "timestamps", value: "\(includeTimestamps ? "true" : "false")")) }

		if let tailAmount {
			let value: String = switch tailAmount {
			case .all:
				"all"
			case .limit(let limit):
				"\(limit)"
			}
			queryItems.append(.init(name: "tail", value: value))
		}

		return queryItems
	}

	func handleResponse(_ response: URLResponse, data: Data) throws -> DecodedResponse {
		var nsString: NSString?
		let encodingRawValue = NSString.stringEncoding(
			for: data,
			encodingOptions: nil,
			convertedString: &nsString,
			usedLossyConversion: nil
		)

		if let nsString, encodingRawValue > 0 {
			return String(nsString)
		}

		if let string = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .ascii) {
			return string
		}

		throw PortainerClient.Error.decodingFailed
	}
}
