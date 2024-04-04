//
//  PortainerClient.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation
import NetworkKit
import OSLog

// MARK: - PortainerClient

public class PortainerClient: @unchecked Sendable {

	// MARK: Static Properties

	internal static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "xyz.shameful.PortainerKit"

	internal static let jsonDecoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .custom { decoder -> Date in
			let dateFormatter = ISO8601DateFormatter()

			let container = try decoder.singleValueContainer()
			do {
				let str = try container.decode(String.self)

				dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
				if let date = dateFormatter.date(from: str) { return date }

				dateFormatter.formatOptions = [.withInternetDateTime]
				if let date = dateFormatter.date(from: str) { return date }

				throw DateError.invalidDate(dateString: str)
			} catch {
				if error is DecodingError {
					let number = try container.decode(TimeInterval.self)
					return Date(timeIntervalSince1970: number)
				}

				throw error
			}
		}
		return decoder
	}()
	internal static let jsonEncoder = JSONEncoder()

	// MARK: Internal Properties

	internal let urlSession: URLSession

	internal let logger = Logger(subsystem: PortainerClient.bundleIdentifier, category: "PortainerClient")
	internal let wsQueue = DispatchQueue(label: PortainerClient.bundleIdentifier.appending(".WebSocket"), qos: .utility)

	// MARK: - Public Properties

	public var serverURL: URL?
	public var token: String?

	// MARK: init

	public init(
		serverURL: URL? = nil,
		token: String? = nil,
		urlSessionConfiguration: URLSessionConfiguration = .default
	) {
		self.serverURL = serverURL
		self.token = token

		let delegate = PortainerClient.URLSessionDelegate()
		self.urlSession = .init(configuration: urlSessionConfiguration, delegate: delegate, delegateQueue: OperationQueue.main)
	}
}

// MARK: - PortainerClient+Internal

internal extension PortainerClient {
	func send<R: NetworkRequest>(_ networkRequest: R) async throws -> R.DecodedResponse {
		guard let serverURL, let token else { throw Error.notSetup }

		var urlRequest = try networkRequest.urlRequest(baseURL: serverURL)
		urlRequest.addValue(token, forHTTPHeaderField: "X-API-Key")

		do {
			let (data, response) = try await urlSession.data(for: urlRequest)

			let decoded = try networkRequest.handleResponse(response, data: data)
			return decoded
		} catch {
			logger.error("Network request failed: \(error, privacy: .public)")
			throw error
		}
	}

	static func handleResponse<T: Decodable>(_ response: URLResponse, data: Data) throws -> T {
		do {
			let decoded = try Self.jsonDecoder.decode(T.self, from: data)
			return decoded
		} catch {
			// Decode error message first...
			if let decoded = try? Self.jsonDecoder.decode(APIError.self, from: data) {
				throw decoded
			}

			// ...if not, get the response status code...
			if let urlResponse = response as? HTTPURLResponse {
				// ...throw response code
				if !(200..<400 ~= urlResponse.statusCode) {
					throw Error.responseCodeUnacceptable(urlResponse.statusCode)
				}
			} else {
				// ...or call assertionFailure, as we can't get the response code
				assertionFailure("Response isn't `HTTPURLResponse`: \(String(describing: response))")
			}

			throw error
		}
	}
}
