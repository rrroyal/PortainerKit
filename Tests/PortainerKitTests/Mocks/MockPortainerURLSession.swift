//
//  MockPortainerURLSession.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

import Foundation
@testable import PortainerKit

// MARK: - MockPortainerURLSession

/// A mocked ``PortainerURLSession`` used to simulate an HTTP response from a Portainer server, without doing any real networking.
///
/// Each test should create its own instance, so tests remain isolated and can run fully in parallel.
actor MockPortainerURLSession: PortainerURLSession {

	/// What the mock should do when `data(for:)` is called.
	enum Behavior {
		/// Return the provided `data`, alongside a `HTTPURLResponse` built from `statusCode` and `headers`.
		case respond(data: Data, statusCode: Int = 200, headers: [String: String] = [:])
		/// Throw the provided `error`.
		case fail(any Error)
	}

	/// Thrown when `data(for:)` is called before a ``Behavior`` has been configured.
	struct UnexpectedRequestError: Error, CustomStringConvertible {
		let request: URLRequest

		var description: String {
			"MockPortainerURLSession received an unexpected request without being configured: \(request)"
		}
	}

	private var behavior: Behavior?
	private(set) var recordedRequests: [URLRequest] = []

	init(behavior: Behavior? = nil) {
		self.behavior = behavior
	}

	/// Configures the response (or error) that should be returned for the next, and any subsequent, requests.
	func setBehavior(_ behavior: Behavior) {
		self.behavior = behavior
	}

	/// The last request seen by this mock, if any.
	var lastRequest: URLRequest? {
		recordedRequests.last
	}

	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		recordedRequests.append(request)

		guard let behavior else {
			throw UnexpectedRequestError(request: request)
		}

		switch behavior {
		case let .respond(data, statusCode, headers):
			guard let url = request.url else {
				throw UnexpectedRequestError(request: request)
			}
			guard let response = HTTPURLResponse(
				url: url,
				statusCode: statusCode,
				httpVersion: "HTTP/1.1",
				headerFields: headers
			) else {
				throw UnexpectedRequestError(request: request)
			}
			return (data, response)
		case let .fail(error):
			throw error
		}
	}
}
