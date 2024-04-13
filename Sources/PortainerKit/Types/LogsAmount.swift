//
//  LogsAmount.swift
//  PortainerKit
//
//  Created by royal on 04/04/2024.
//  Copyright © 2023 shameful. All rights reserved.
//

// MARK: - LogsAmount

public enum LogsAmount: Sendable {
	case all
	case limit(Int)
}

// MARK: - LogsAmount+ExpressibleByIntegerLiteral

extension LogsAmount: ExpressibleByIntegerLiteral {
	public init(integerLiteral val: Int) {
		self = .limit(val)
	}
}
