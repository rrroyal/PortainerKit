//
//  SystemVersion.swift
//  PortainerKit
//
//  Created by royal on 13/04/2025.
//

public struct SystemStatus: Equatable, Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case version = "Version"
		case instanceID = "InstanceID"
	}

	public let version: String
	public let instanceID: String?
}
