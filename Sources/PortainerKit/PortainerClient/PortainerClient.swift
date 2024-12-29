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

public class PortainerClient {

	// MARK: Static Properties

	private static let jsonDecoder = JSONDecoder.portainer
	private static let jsonEncoder = JSONEncoder.portainer

	public static let bundleIdentifier = "xyz.shameful.PortainerKit"

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
		self.urlSession = .init(configuration: urlSessionConfiguration, delegate: delegate, delegateQueue: .current)
	}
}

// MARK: - PortainerClient+Internal

internal extension PortainerClient {
	func send<R: NetworkRequest>(_ networkRequest: R) async throws -> R.ResponseBody {
		guard let serverURL, let token else { throw ClientError.notSetup }

		var urlRequest = try networkRequest.urlRequest(baseURL: serverURL)
		urlRequest.addValue(token, forHTTPHeaderField: "X-API-Key")

		#if DEBUG
		logger.debug("📤 \(String(describing: networkRequest)) \(urlRequest)")
		#endif

		do {
			let (data, response) = try await urlSession.data(for: urlRequest)

			#if DEBUG
			logger.debug("📥 \(response), \(data.isEmpty ? "<no data>" : String(data: data, encoding: .utf8) ?? data.base64EncodedString())")
			#endif

			let decoded = try networkRequest.handleResponse(response, data: data)
			return decoded
		} catch {
			#if DEBUG
			logger.error("Network request failed: \(error, privacy: .public)")
			#endif
			throw error
		}
	}

	static func handleResponse<T: Decodable>(_ response: URLResponse, data: Data) throws -> T {
		do {
			let decoded = try Self.jsonDecoder.decode(T.self, from: data)
			return decoded
		} catch {
			throw handleErrorResponse(response, data: data) ?? error
		}
	}

	static func handleErrorResponse(_ response: URLResponse, data: Data) -> Error? {
		// Decode error message first...
		if let decoded = try? Self.jsonDecoder.decode(APIError.self, from: data) {
			return decoded
		}

		// ...if not, get the response status code...
		if let urlResponse = response as? HTTPURLResponse {
			// ...throw response code
			if !(200..<400 ~= urlResponse.statusCode) {
				return ClientError.responseCodeUnacceptable(urlResponse.statusCode)
			}
		} else {
			// ...or call assertionFailure, as we can't get the response code
			assertionFailure("Response isn't `HTTPURLResponse`: \(String(describing: response))")
		}

		return nil
	}
}
