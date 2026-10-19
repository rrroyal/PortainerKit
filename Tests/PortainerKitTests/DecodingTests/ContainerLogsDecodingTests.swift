//
//  ContainerLogsDecodingTests.swift
//  PortainerKitTests
//
//  Created by royal on 19/10/2026.
//

import Foundation
@testable import PortainerKit
import Testing

// MARK: - ContainerLogsDecodingTests

/// Tests that ``PortainerClient`` strips Docker's stream frame headers from container logs.
@Suite(.tags(.networking, .decoding, .containers))
struct ContainerLogsDecodingTests {
	private typealias Support = DecodingTestSupport

	private func frame(_ payload: String, stream: UInt8 = 1) -> Data {
		let payload = Data(payload.utf8)
		let size = UInt32(payload.count).bigEndian
		return Data([stream, 0, 0, 0]) + withUnsafeBytes(of: size) { Data($0) } + payload
	}

	private func fetchLogs(_ data: Data) async throws -> String {
		let (client, session) = try Support.makeClient()
		await session.setBehavior(.respond(data: data))
		return try await client.fetchContainerLogs(for: Support.containerID, endpointID: Support.endpointID)
	}

	@Test("Strips the header of a frame whose size byte is a newline")
	func decodeNewlineSizedFrame() async throws {
		let data = frame("0123456789")
		#expect(data[7] == 0x0A)
		#expect(try await fetchLogs(data) == "0123456789")
	}

	@Test("Decodes a 200-byte UTF-8 frame")
	func decodeUTF8Frame() async throws {
		let line = String(repeating: "é🐳", count: 33) + "!\n"
		let data = frame(line)
		#expect(data.count == 8 + 200)
		#expect(try await fetchLogs(data) == line)
	}

	@Test("Concatenates multiple stdout and stderr frames")
	func decodeMultipleFrames() async throws {
		let data = frame("out\n") + frame("err\r\n", stream: 2) + frame("more\n")
		#expect(try await fetchLogs(data) == "out\nerr\r\nmore\n")
	}

	@Test("Doesn't read past a truncated frame")
	func decodeTruncatedFrame() async throws {
		let data = frame("first\n") + frame("second\n").prefix(10)
		#expect(try await fetchLogs(data) == "first\nse")
	}

	@Test("Returns raw TTY logs as-is")
	func decodeRawTTYLogs() async throws {
		let logs = "2026-10-19T12:00:00Z Starting…\r\nReady ✅\n"
		#expect(try await fetchLogs(Data(logs.utf8)) == logs)
	}
}
