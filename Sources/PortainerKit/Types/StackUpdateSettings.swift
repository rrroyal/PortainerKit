//
//  StackUpdateSettings.swift
//  PortainerKit
//
//  Created by royal on 07/05/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public struct StackUpdateSettings: Encodable {
	public var env: [Stack.EnvironmentEntry]
	public var prune: Bool
	public var pullImage: Bool
	public var stackFileContent: String

	public init(env: [Stack.EnvironmentEntry], prune: Bool, pullImage: Bool, stackFileContent: String) {
		self.env = env
		self.prune = prune
		self.pullImage = pullImage
		self.stackFileContent = stackFileContent
	}
}
