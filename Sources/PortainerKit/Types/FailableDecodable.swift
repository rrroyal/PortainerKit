//
//  FailableDecodable.swift
//  PortainerKit
//
//  Created by royal on 19/10/2026.
//  Copyright © 2026 shameful. All rights reserved.
//

import Foundation
import OSLog

// MARK: - FailableDecodable

/// Wraps a `Decodable` value, decoding it to `nil` instead of throwing, so one odd element doesn't fail the whole array.
public struct FailableDecodable<Wrapped: Decodable>: Decodable {
	public let value: Wrapped?

	public init(from decoder: any Decoder) throws {
		self.value = try? Wrapped(from: decoder)
	}
}

// MARK: - FailableDecodable+Sendable

extension FailableDecodable: Sendable where Wrapped: Sendable { }

// MARK: - Array+FailableDecodable

extension Array {
	/// Returns the successfully decoded values, logging how many elements were dropped.
	func decodedValues<Wrapped>() -> [Wrapped] where Element == FailableDecodable<Wrapped> {
		let values = compactMap(\.value)
		let droppedCount = count - values.count
		if droppedCount > 0 {
			Logger(subsystem: PortainerClient.bundleIdentifier, category: "Decoding")
				.warning("Dropped \(droppedCount, privacy: .public) undecodable \(String(describing: Wrapped.self), privacy: .public) element(s)")
		}
		return values
	}
}

// MARK: - KeyedDecodingContainer+FailableDecodable

extension KeyedDecodingContainer {
	/// Decodes an array, dropping elements that can't be decoded instead of throwing.
	func decodeFailableArrayIfPresent<T: Decodable>(_ type: [T].Type, forKey key: Key) throws -> [T]? {
		try decodeIfPresent([FailableDecodable<T>].self, forKey: key)?.decodedValues()
	}
}
