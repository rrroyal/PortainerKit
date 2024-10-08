//
//  StackDeployment.DeploymentSettings+StandaloneString.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

public extension StackDeployment.DeploymentSettings {
	struct StandaloneString: StackDeploymentSettings, Sendable {
		public let deploymentType: StackDeployment.DeploymentType = .standalone
		public let deploymentMethod: StackDeployment.DeploymentMethod = .string

		public var env: [Stack.EnvironmentEntry] = []
		public var fromAppTemplate: Bool?
		public var name: String
		public var stackFileContent: String

		public init(
			env: [Stack.EnvironmentEntry] = [],
			fromAppTemplate: Bool? = nil,
			name: String,
			stackFileContent: String
		) {
			self.env = env
			self.fromAppTemplate = fromAppTemplate
			self.name = name
			self.stackFileContent = stackFileContent
		}
	}
}
