//
//  StackDeploymentSettings.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public protocol StackDeploymentSettings: Encodable {
	var deploymentType: StackDeployment.DeploymentType { get }
	var deploymentMethod: StackDeployment.DeploymentMethod { get }
}
