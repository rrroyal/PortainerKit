//
//  SystemStatusRequest.swift
//  PortainerKit
//
//  Created by royal on 13/04/2025.
//

import Foundation
import NetworkKit

struct SystemStatusRequest { }

// MARK: - SystemStatusRequest+NetworkRequest

extension SystemStatusRequest: NetworkRequest {
	typealias ResponseBody = SystemStatus

	var method: HTTPMethod { .get }
	var path: String { "/api/system/status" }
}
