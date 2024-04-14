//
//  StackDeployment+DeploymentType.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension StackDeployment {
	enum DeploymentType: String, Codable {
		case kubernetes
		case standalone
		case swarm
	}
}
