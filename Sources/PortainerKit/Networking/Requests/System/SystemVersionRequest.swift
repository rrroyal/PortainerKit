//
//  SystemVersionRequest.swift
//  PortainerKit
//
//  Created by royal on 13/04/2025.
//

import Foundation
import NetworkKit

struct SystemVersionRequest { }

// MARK: - SystemVersionRequest+NetworkRequest

extension SystemVersionRequest: NetworkRequest {
	typealias ResponseBody = SystemVersion

	var method: HTTPMethod { .get }
	var path: String { "/api/system/version" }
}
