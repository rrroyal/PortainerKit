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
		case build = "Build"
		case databaseVersion = "DatabaseVersion"
		case serverVersion = "ServerVersion"
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
		enum CodingKeys: String, CodingKey {
			case buildNumber = "BuildNumber"
			case gitCommit = "GitCommit"
			case imageTag = "ImageTag"
		}

		public let buildNumber: String
		public let gitCommit: String
		public let imageTag: String
	}
}
