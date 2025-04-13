//
//  SystemVersion.swift
//  PortainerKit
//
//  Created by royal on 13/04/2025.
//

public struct SystemVersion: Equatable, Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case latestVersion = "LatestVersion"
		case serverEdition = "ServerEdition"
		case updateAvailable = "UpdateAvailable"
		case build
		case databaseVersion = "databaseVersion"
		case serverVersion = "serverVersion"
	}

	public let latestVersion: String?
	public let serverEdition: String
	public let updateAvailable: Bool
	public let build: Build?
	public let databaseVersion: String?
	public let serverVersion: String?
}

public extension SystemVersion {
	struct Build: Equatable, Codable, Sendable {
		public let buildNumber: String
		public let env: [String]
		public let gitCommit: String
		public let imageTag: String
	}
}
