//
//  PortainerClient+PortainerError.swift
//  PortainerKit
//
//  Created by royal on 01/10/2022.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

public extension PortainerClient {
	enum Error: Swift.Error {
		case notSetup

		case other(_ reason: String)
		case unknownError

		case responseCodeUnacceptable(_ code: Int)

		case encodingFailed
		case decodingFailed

		case invalidURL
		case invalidRequest
		case invalidResponse
	}
}
