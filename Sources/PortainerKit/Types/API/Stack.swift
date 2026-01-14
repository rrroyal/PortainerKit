//
//  Stack.swift
//  PortainerKit
//
//  Created by royal on 06/06/2023.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

// MARK: - Stack

public struct Stack: Identifiable, Equatable, Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case id = "Id"
		case name = "Name"
		case type = "Type"
		case endpointID = "EndpointId"
		case env = "Env"
		case status = "Status"
		case entrypoint = "EntryPoint"
		case creationDate = "CreationDate"
		case createdBy = "CreatedBy"
		case updateDate = "UpdateDate"
		case updatedBy = "UpdatedBy"
		case autoUpdate = "AutoUpdate"
		case gitConfig = "GitConfig"
	}

	/// Stack Identifier
	public let id: Int

	/// Stack name
	public let name: String

	/// Stack type. 1 for a Swarm stack, 2 for a Compose stack
	public let type: StackType

	/// Environment(Endpoint) identifier. Reference the environment(endpoint) that will be used for deployment
	public let endpointID: Int

	/// A list of environment(endpoint) variables used during stack deployment
	public let env: [EnvironmentEntry]?

	/// Stack status (1 - active, 2 - inactive)
	public var status: Status?

	/// Path to the Stack file
	public let entrypoint: String?

	/// The date in unix time when stack was created
	public let creationDate: Date?

	/// The username which created this stack
	public let createdBy: String?

	/// The date in unix time when stack was last updated
	public let updateDate: Date?

	/// The username which last updated this stack
	public let updatedBy: String?

	/// The GitOps update settings of a git stack
	public let autoUpdate: AutoUpdate?

	/// The git config of this stack
	public let gitConfig: GitConfig?

	public init(
		id: Int,
		name: String,
		type: StackType,
		endpointID: Int,
		env: [EnvironmentEntry]? = nil,
		status: Status? = nil,
		entrypoint: String? = nil,
		creationDate: Date? = nil,
		createdBy: String? = nil,
		updateDate: Date? = nil,
		updatedBy: String? = nil,
		autoUpdate: AutoUpdate? = nil,
		gitConfig: GitConfig? = nil
	) {
		self.id = id
		self.name = name
		self.type = type
		self.endpointID = endpointID
		self.env = env
		self.status = status
		self.entrypoint = entrypoint
		self.creationDate = creationDate
		self.createdBy = createdBy
		self.updateDate = updateDate
		self.updatedBy = updatedBy
		self.autoUpdate = autoUpdate
		self.gitConfig = gitConfig
	}
}

// MARK: - Stack+StackType

public extension Stack {
	enum StackType: Int, Equatable, Codable, Sendable {
		case swarm = 1
		case dockerCompose = 2
		case kubernetes = 3
	}
}

// MARK: - Stack+Status

public extension Stack {
	enum Status: Int, Equatable, Codable, Sendable {
		case active = 1
		case inactive = 2
	}
}

// MARK: - Stack+EnvironmentEntry

public extension Stack {
	struct EnvironmentEntry: Equatable, Codable, Hashable, Sendable {
		public let name: String
		public let value: String

		public init(name: String, value: String) {
			self.name = name
			self.value = value
		}
	}
}

// MARK: - Stack+AutoUpdate

public extension Stack {
	struct AutoUpdate: Equatable, Codable, Hashable, Sendable {
		enum CodingKeys: String, CodingKey {
			case interval = "Interval"
//			case webhook = "Webhook"
//			case jobID = "JobID"
			case forceUpdate = "ForceUpdate"
			case forcePullImage = "ForcePullImage"
		}

		public let interval: String
//		public let webhook: String
//		public let jobID: String
		public let forceUpdate: Bool
		public let forcePullImage: Bool
	}
}

// MARK: - Stack+GitConfig

public extension Stack {
	struct GitConfig: Equatable, Codable, Hashable, Sendable {
		enum CodingKeys: String, CodingKey {
			case url = "URL"
			case referenceName = "ReferenceName"
			case configFilePath = "ConfigFilePath"
//			case Authentication = "Authentication"
//			case ConfigHash = "ConfigHash"
//			case TLSSkipVerify = "TLSSkipVerify"
		}

		public let url: URL
		public let referenceName: String
		public let configFilePath: String
//		public let Authentication: ?
//		public let ConfigHash: String
//		public let TLSSkipVerify: false
	}
}

extension [Stack.EnvironmentEntry]: @retroactive ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (String, String)...) {
		self = elements.map { .init(name: $0, value: $1) }
	}
}
