//
//  JSONEncoder+portainer.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

extension JSONEncoder {
	static let portainer: JSONEncoder = {
		let encoder = JSONEncoder()
		return encoder
	}()
}
