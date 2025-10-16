//
//  Device.swift
//  PortainerKit
//
//  Created by enzofrnt on 16/10/2025.
//

public struct Device: Codable, Equatable, Sendable {
	enum CodingKeys: String, CodingKey {
		case pathOnHost = "PathOnHost"
		case pathInContainer = "PathInContainer"
		case cgroupPermissions = "CgroupPermissions"
	}

	public let pathOnHost: String?
	public let pathInContainer: String?
	public let cgroupPermissions: String?
}
