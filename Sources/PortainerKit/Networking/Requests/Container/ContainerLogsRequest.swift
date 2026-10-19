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
	typealias ResponseBody = String

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints/\(endpointID)/docker/containers/\(containerID)/logs" }

	var queryItems: [URLQueryItem]? {
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

	func handleResponse(_ response: URLResponse, data: Data) throws -> ResponseBody {
		if !((200..<300) ~= ((response as? HTTPURLResponse)?.statusCode ?? 0)), let error = PortainerClient.handleErrorResponse(response, data: data) {
			throw error
		}

		// Lossy on purpose - invalid UTF-8 in logs shouldn't fail the whole request.
		// swiftlint:disable:next optional_data_string_conversion
		return String(decoding: Self.demultiplexed(data), as: UTF8.self)
	}

	/// Strips the 8-byte frame headers (`[stream, 0, 0, 0, size (UInt32, big-endian)]`) Docker adds to non-TTY logs.
	/// TTY logs aren't framed and are returned as-is.
	static func demultiplexed(_ data: Data) -> Data {
		let bytes = [UInt8](data)
		guard bytes.count >= 8, bytes[0] <= 2, bytes[1...3].allSatisfy({ $0 == 0 }) else {
			return data
		}

		var payload = Data(capacity: bytes.count)
		var offset = 0
		while offset + 8 <= bytes.count {
			let size = bytes[(offset + 4)..<(offset + 8)].reduce(0) { $0 << 8 | Int($1) }
			let start = offset + 8
			let end = min(start + size, bytes.count)
			payload.append(contentsOf: bytes[start..<end])
			offset = end
		}
		return payload
	}
}
