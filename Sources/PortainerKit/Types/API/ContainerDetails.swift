//
//  ContainerDetails.swift
//  PortainerKit
//
//  Created by royal on 17/07/2022.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

// MARK: - ContainerDetails

public struct ContainerDetails: Codable, Equatable, Identifiable, Sendable {
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case created = "Created"
		case platform = "Platform"
		case path = "Path"
		case args = "Args"
		case state = "State"
		case image = "Image"
		case name = "Name"
		case restartCount = "RestartCount"
		case mountLabel = "MountLabel"
		case mounts = "Mounts"
		case config = "Config"
		case networkSettings = "NetworkSettings"
		case hostConfig = "HostConfig"
	}

	public let id: String
	public let created: Date
	public let platform: String
	public let path: String
	public let args: [String]
	public let state: ContainerDetails.State
	public let image: String
	public let name: String
	public let restartCount: Int
	public let mountLabel: String
	public let config: ContainerConfig?
	public let mounts: [MountPoint]
	public let networkSettings: NetworkSettings
	public let hostConfig: HostConfig
}

// MARK: - ContainerDetails+State

public extension ContainerDetails {
	struct State: Codable, Equatable, Sendable {
		enum CodingKeys: String, CodingKey {
			case state = "Status"
			case running = "Running"
			case paused = "Paused"
			case restarting = "Restarting"
			case oomKilled = "OOMKilled"
			case dead = "Dead"
			case pid = "Pid"
			case error = "Error"
			case startedAt = "StartedAt"
			case finishedAt = "FinishedAt"
			case health = "Health"
		}

		public let state: Container.State
		public let running: Bool
		public let paused: Bool
		public let restarting: Bool
		public let oomKilled: Bool
		public let dead: Bool
		public let pid: Int
		public let error: String?
		public let startedAt: Date?
		public let finishedAt: Date?
		public let health: Health?
	}
}

// MARK: - ContainerDetails.State+Health

public extension ContainerDetails.State {
	struct Health: Codable, Equatable, Sendable {
		enum CodingKeys: String, CodingKey {
			case failingStreak = "FailingStreak"
			case log = "Log"
			case status = "Status"
		}

		public let failingStreak: Int
		public let log: [Log]?
		public let status: String?
	}
}

// MARK: - ContainerDetails.State.Health+Log

public extension ContainerDetails.State.Health {
	struct Log: Codable, Equatable, Hashable, Sendable {
		enum CodingKeys: String, CodingKey {
			case start = "Start"
			case end = "End"
			case output = "Output"
			case exitCode = "ExitCode"
		}

		public let start: Date
		public let end: Date?
		public let output: String
		public let exitCode: Int?
	}
}

// MARK: - ContainerDetails+NetworkSettings

public extension ContainerDetails {
	struct NetworkSettings: Codable, Equatable, Sendable {
		enum CodingKeys: String, CodingKey {
			case bridge = "Bridge"
			case gateway = "Gateway"
			case address = "Address"
			case ipAddress = "IPAddress"
			case ipPrefixLen = "IPPrefixLen"
			case macAddress = "MacAddress"
			case portMapping = "PortMapping"
			case ports = "Ports"
			case networks = "Networks"
		}

		public let bridge: String
		public let gateway: String
		public let address: String?
		public let ipAddress: String?
		public let ipPrefixLen: Int
		public let macAddress: String
		public let portMapping: String?
		public let ports: Port
		public let networks: [String: Network]?
	}
}

// MARK: - ContainerDetails+HostConfig

public extension ContainerDetails {
	struct HostConfig: Codable, Equatable, Sendable {
		enum CodingKeys: String, CodingKey {
			case portBindings = "PortBindings"
		}

		public let portBindings: [String: [PortBinding]]?
	}
}

// MARK: - ContainerDetails.HostConfig+PortBinding

public extension ContainerDetails.HostConfig {
	struct PortBinding: Codable, Equatable, Sendable {
		enum CodingKeys: String, CodingKey {
			case hostIP = "HostIP"
			case hostPort = "HostPort"
		}

		public let hostIP: String?
		public let hostPort: String?
	}
}
