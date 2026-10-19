//
//  EndpointsRequest.swift
//  PortainerKit
//
//  Created by royal on 03/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import NetworkKit

// MARK: - EndpointsRequest

struct EndpointsRequest { }

// MARK: - EndpointsRequest+NetworkRequest

extension EndpointsRequest: NetworkRequest {
	typealias ResponseBody = [FailableDecodable<Endpoint>]

	var method: HTTPMethod { .get }
	var path: String { "/api/endpoints" }
}
