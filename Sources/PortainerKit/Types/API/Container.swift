//
//  Container.swift
//  PortainerKit
//
//  Created by royal on 17/07/2022.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

// MARK: - Container

public struct Container: Identifiable, Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case names = "Names"
		case image = "Image"
		case imageID = "ImageID"
		case command = "Command"
		case created = "Created"
		case ports = "Ports"
		case labels = "Labels"
		case state = "State"
		case status = "Status"
		case mounts = "Mounts"
	}

	public let id: String
	public let names: [String]?
	public let image: String?
	public let imageID: String?
	public let command: String?
	public let created: Date?
	public let ports: [Port]?
	public let labels: [String: String]?
	public var state: Container.State?
	public let status: String?
	public let mounts: [Mount]?

	public init(
		id: String,
		names: [String]? = nil,
		image: String? = nil,
		imageID: String? = nil,
		command: String? = nil,
		created: Date? = nil,
		ports: [Port]? = nil,
		labels: [String: String]? = nil,
		state: Container.State? = nil,
		status: String? = nil,
		mounts: [Mount]? = nil
	) {
		self.id = id
		self.names = names
		self.image = image
		self.imageID = imageID
		self.command = command
		self.created = created
		self.ports = ports
		self.labels = labels
		self.state = state
		self.status = status
		self.mounts = mounts
	}
}

// MARK: - Container+State

public extension Container {
	enum State: String, Codable, Sendable, Equatable {
		case created
		case running
		case paused
		case restarting
		case removing
		case exited
		case dead
	}
}

// MARK: - Container+Equatable

extension Container: Equatable {
	public static func == (lhs: Container, rhs: Container) -> Bool {
		lhs.id == rhs.id &&
		lhs.image == rhs.image &&
		lhs.imageID == rhs.imageID &&
		lhs.state == rhs.state &&
		lhs.status == rhs.status &&
		lhs.created == rhs.created &&
		lhs.names == rhs.names &&
		lhs.command == rhs.command &&
		lhs.labels == rhs.labels &&
		lhs.ports == rhs.ports &&
		lhs.mounts == rhs.mounts
	}
}

// MARK: - Container+Hashable

extension Container: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(names)
		hasher.combine(image)
		hasher.combine(imageID)
		hasher.combine(command)
		hasher.combine(created)
//		hasher.combine(ports)
		hasher.combine(labels)
		hasher.combine(state)
		hasher.combine(status)
//		hasher.combine(networkSettings)
//		hasher.combine(mounts)
	}
}
