//
//  PortainerClient+ClientError.swift
//  PortainerKit
//
//  Created by royal on 01/10/2022.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension PortainerClient {
	enum ClientError: Error {
		case notSetup

		case responseCodeUnacceptable(_ code: Int)

		case encodingFailed
		case decodingFailed
	}
}
