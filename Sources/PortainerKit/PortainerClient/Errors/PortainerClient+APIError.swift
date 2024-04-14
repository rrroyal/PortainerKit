//
//  PortainerClient+APIError.swift
//  PortainerKit
//
//  Created by royal on 10/06/2021.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension PortainerClient {
	struct APIError: Codable {
		public let message: String?
		public let details: String?
	}
}

extension PortainerClient.APIError: LocalizedError {
	public var errorDescription: String? {
		message?.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	public var failureReason: String? {
		details?.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

public extension PortainerClient.APIError {
	var isAuthorizationError: Bool {
		guard let message else { return false }
		return message.localizedCaseInsensitiveContains("invalid jwt token") ||
			message.localizedCaseInsensitiveContains("a valid authorisation token is missing") ||
			message.localizedCaseInsensitiveContains("unauthorized")
	}
}
