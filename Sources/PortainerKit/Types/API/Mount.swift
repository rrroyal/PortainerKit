//
//  Mount.swift
//  PortainerKit
//
//  Created by royal on 17/07/2022.
//  Copyright © 2024 shameful. All rights reserved.
//

public struct Mount: Equatable, Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case type = "Type"
		case name = "Name"
		case source = "Source"
		case destination = "Destination"
		case driver = "Driver"
		case mode = "Mode"
		case rw = "RW"
		case propagation = "Propagation"
	}

	public let type: MountType?
	public let name: String?
	public let source: String?
	public let destination: String?
	public let driver: String?
	public let mode: String?
	public let rw: Bool?
	public let propagation: String?
}

public extension Mount {
	enum MountType: String, Equatable, Codable, Sendable {
		case bind
		case volume
		case image
		case tmpfs
		case npipe
		case cluster
	}
}
