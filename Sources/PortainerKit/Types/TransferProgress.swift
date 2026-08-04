//
//  TransferProgress.swift
//  PortainerKit
//

import Foundation

/// Progress reported while sending a request or receiving its response.
public struct TransferProgress: Equatable, Sendable {
	/// The direction of the transfer.
	public enum Direction: Equatable, Sendable {
		case request
		case response
	}

	/// The transfer direction.
	public let direction: Direction
	/// The number of bytes transferred so far.
	public let completedByteCount: Int64
	/// The expected byte count, or `nil` when the server doesn't provide one.
	public let expectedByteCount: Int64?

	/// The completed fraction when the total byte count is known.
	public var fractionCompleted: Double? {
		guard let expectedByteCount else { return nil }
		if expectedByteCount == 0 {
			return completedByteCount == 0 ? 1 : nil
		}
		guard expectedByteCount > 0 else { return nil }
		return min(Double(completedByteCount) / Double(expectedByteCount), 1)
	}

	public init(direction: Direction, completedByteCount: Int64, expectedByteCount: Int64?) {
		self.direction = direction
		self.completedByteCount = completedByteCount
		self.expectedByteCount = expectedByteCount
	}
}

/// Receives request and response transfer progress updates.
public typealias TransferProgressHandler = @Sendable (TransferProgress) -> Void
