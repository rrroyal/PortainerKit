//
//  ErrorHandlingDecodingTests.swift
//  PortainerKitTests
//
//  Created by Copilot on 07/07/2026.
//

import Foundation
@testable import PortainerKit
import Testing

// MARK: - ErrorHandlingDecodingTests

/// Tests that ``PortainerClient``'s generic response handling surfaces the right errors for non-2xx responses,
/// regardless of which endpoint was called.
@Suite(.tags(.networking, .decoding, .errorHandling))
struct ErrorHandlingDecodingTests {
	private typealias Support = DecodingTestSupport

	@Test("Throws PortainerClient.APIError when the server returns a Portainer-style error body")
	func decodeErrorResponseThrowsAPIError() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: try Support.fixture("error_unauthorized"), statusCode: 401))

		do {
			_ = try await client.fetchEndpoints()
			Issue.record("Expected fetchEndpoints to throw for a 401 response, but it succeeded.")
		} catch let error as PortainerClient.APIError {
			#expect(error.message == "a valid authorisation token is missing")
			#expect(error.isAuthorizationError)
		} catch {
			Issue.record("Expected a PortainerClient.APIError, but got \(error) instead.")
		}
	}

	@Test("Throws ClientError.responseCodeUnacceptable for a non-2xx response with no parseable error body")
	func decodeUnacceptableStatusCodeThrows() async throws {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: Data("not json".utf8), statusCode: 500))

		do {
			_ = try await client.fetchEndpoints()
			Issue.record("Expected fetchEndpoints to throw for a 500 response, but it succeeded.")
		} catch PortainerClient.ClientError.responseCodeUnacceptable(let code) {
			#expect(code == 500)
		} catch {
			Issue.record("Expected ClientError.responseCodeUnacceptable, but got \(error) instead.")
		}
	}
}
