//
//  PortainerClient+DateError.swift
//  PortainerKit
//
//  Created by royal on 01/10/2022.
//  Copyright © 2023 shameful. All rights reserved.
//

import Foundation

extension PortainerClient {
	enum DateError: Swift.Error {
		case invalidDate(dateString: String)
	}
}
