//
//  PortainerURLSession.swift
//  PortainerKit
//
//  Created by royal on 07/07/2026.
//

import Foundation

/// Abstraction over `URLSession`'s networking surface used by ``PortainerClient``, allowing tests to inject a mocked session.
internal protocol PortainerURLSession: Sendable {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
	func data(for request: URLRequest, progressHandler: TransferProgressHandler?) async throws -> (Data, URLResponse)
}

// MARK: - URLSession+PortainerURLSession

extension URLSession: PortainerURLSession {
	func data(for request: URLRequest, progressHandler: TransferProgressHandler?) async throws -> (Data, URLResponse) {
		guard let progressHandler else {
			return try await data(for: request)
		}

		let delegate = PortainerClient.TransferProgressDelegate(progressHandler: progressHandler)
		let (bytes, response) = try await bytes(for: request, delegate: delegate)
		if let requestBody = request.httpBody, requestBody.isEmpty {
			progressHandler(.init(direction: .request, completedByteCount: 0, expectedByteCount: 0))
		}
		let expectedByteCount = response.expectedContentLength > 0 ? response.expectedContentLength : nil
		var responseData = Data()
		if let expectedByteCount {
			responseData.reserveCapacity(Int(expectedByteCount))
		}

		var completedByteCount: Int64 = 0
		for try await byte in bytes {
			responseData.append(byte)
			completedByteCount += 1
			if completedByteCount.isMultiple(of: 1024) {
				progressHandler(.init(
					direction: .response,
					completedByteCount: completedByteCount,
					expectedByteCount: expectedByteCount
				))
			}
		}

		progressHandler(.init(
			direction: .response,
			completedByteCount: completedByteCount,
			expectedByteCount: expectedByteCount ?? completedByteCount
		))
		return (responseData, response)
	}
}
