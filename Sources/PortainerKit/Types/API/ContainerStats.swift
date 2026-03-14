//
//  ContainerStats.swift
//  PortainerKit
//
//  Created by royal on 14/03/2026.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

// MARK: - ContainerStats

public struct ContainerStats: Codable, Sendable {
	enum CodingKeys: String, CodingKey {
		case cpuStats = "cpu_stats"
		case precpuStats = "precpu_stats"
		case memoryStats = "memory_stats"
		case networks = "networks"
	}

	public let cpuStats: CPUStats
	public let precpuStats: CPUStats
	public let memoryStats: MemoryStats
	public let networks: [String: NetworkStats]?
}

// MARK: - ContainerStats+CPUStats

public extension ContainerStats {
	struct CPUStats: Codable, Sendable {
		enum CodingKeys: String, CodingKey {
			case cpuUsage = "cpu_usage"
			case systemCPUUsage = "system_cpu_usage"
			case onlineCPUs = "online_cpus"
		}

		public let cpuUsage: CPUUsage
		public let systemCPUUsage: UInt64?
		public let onlineCPUs: Int?
	}
}

// MARK: - ContainerStats.CPUStats+CPUUsage

public extension ContainerStats.CPUStats {
	struct CPUUsage: Codable, Sendable {
		enum CodingKeys: String, CodingKey {
			case totalUsage = "total_usage"
			case percpuUsage = "percpu_usage"
		}

		public let totalUsage: UInt64
		public let percpuUsage: [UInt64]?
	}
}

// MARK: - ContainerStats+MemoryStats

public extension ContainerStats {
	struct MemoryStats: Codable, Sendable {
		enum CodingKeys: String, CodingKey {
			case usage = "usage"
			case limit = "limit"
			case stats = "stats"
		}

		public let usage: UInt64?
		public let limit: UInt64?
		public let stats: MemoryStatsDetails?
	}
}

// MARK: - ContainerStats.MemoryStats+MemoryStatsDetails

public extension ContainerStats.MemoryStats {
	struct MemoryStatsDetails: Codable, Sendable {
		enum CodingKeys: String, CodingKey {
			case cache = "cache"
			case inactiveFile = "inactive_file"
		}

		public let cache: UInt64?
		public let inactiveFile: UInt64?
	}
}

// MARK: - ContainerStats+NetworkStats

public extension ContainerStats {
	struct NetworkStats: Codable, Sendable {
		enum CodingKeys: String, CodingKey {
			case rxBytes = "rx_bytes"
			case txBytes = "tx_bytes"
		}

		public let rxBytes: UInt64
		public let txBytes: UInt64
	}
}

// MARK: - ContainerStats+Computed

public extension ContainerStats {
	/// CPU usage percentage (0–100 * numCPUs).
	var cpuUsagePercent: Double? {
		let cpuDelta = Double(cpuStats.cpuUsage.totalUsage) - Double(precpuStats.cpuUsage.totalUsage)
		guard
			let systemCurrent = cpuStats.systemCPUUsage,
			let systemPrev = precpuStats.systemCPUUsage
		else { return nil }
		let systemDelta = Double(systemCurrent) - Double(systemPrev)
		guard systemDelta > 0 else { return nil }
		let numCPUs = Double(cpuStats.onlineCPUs ?? cpuStats.cpuUsage.percpuUsage?.count ?? 1)
		return (cpuDelta / systemDelta) * numCPUs * 100.0
	}

	/// Memory usage in bytes, excluding cache.
	var memoryUsageBytes: UInt64? {
		guard let usage = memoryStats.usage else { return nil }
		let cache = memoryStats.stats?.inactiveFile ?? memoryStats.stats?.cache ?? 0
		return usage > cache ? usage - cache : usage
	}

	/// Memory limit in bytes.
	var memoryLimitBytes: UInt64? {
		memoryStats.limit
	}
}
