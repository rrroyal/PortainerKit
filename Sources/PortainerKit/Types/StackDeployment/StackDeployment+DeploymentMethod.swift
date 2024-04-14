//
//  StackDeployment+DeploymentMethod.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension StackDeployment {
	enum DeploymentMethod: String, Codable {
		//	case file
		case string
		case repository
		case url
	}
}
