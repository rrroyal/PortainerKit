//
//  FetchFilters.swift
//  PortainerKit
//
//  Created by royal on 08/06/2023.
//  Copyright © 2023 shameful. All rights reserved.
//

public struct FetchFilters: Codable, Sendable {
	public var id: [String]?
	public var name: [String]?
	public var label: [String]?
	public var status: [String]?
	public var before: [String]?
	public var since: [String]?

	public init() { }

	public init(
		id: [String]? = nil,
		name: [String]? = nil,
		label: [String]? = nil,
		status: [String]? = nil,
		before: [String]? = nil,
		since: [String]? = nil
	) {
		self.id = id
		self.name = name
		self.label = label
		self.status = status
		self.before = before
		self.since = since
	}
}
