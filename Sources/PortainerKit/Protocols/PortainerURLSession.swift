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
}

// MARK: - URLSession+PortainerURLSession

extension URLSession: PortainerURLSession {}
