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

	public init(
		id: Int,
		name: String,
		type: StackType,
		endpointID: Int,
		env: [EnvironmentEntry]?,
		status: Status? = nil
	) {
		self.id = id
		self.name = name
		self.type = type
		self.endpointID = endpointID
		self.env = env
		self.status = status
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
	struct EnvironmentEntry: Equatable, Codable, Sendable, Hashable {
		public let name: String
		public let value: String

		public init(name: String, value: String) {
			self.name = name
			self.value = value
		}
	}
}

extension [Stack.EnvironmentEntry]: ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (String, String)...) {
		self = elements.map { .init(name: $0, value: $1) }
	}
}
