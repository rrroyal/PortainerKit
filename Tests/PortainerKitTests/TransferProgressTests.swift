import Foundation
import os
@testable import PortainerKit
import Testing

@Suite(.tags(.networking, .stacks))
struct TransferProgressTests {
	@Test
	func `URLSession reports request and response progress`() async throws {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [StubURLProtocol.self]
		let session = URLSession(configuration: configuration)
		defer { session.invalidateAndCancel() }

		var request = try URLRequest(url: #require(URL(string: "https://portainer.example.com/api/stacks")))
		request.httpBody = Data()

		let values = OSAllocatedUnfairLock<[TransferProgress]>(initialState: [])
		let (data, _) = try await session.data(for: request) { progress in
			values.withLock { $0.append(progress) }
		}

		let progress = values.withLock { $0 }
		#expect(data == StubURLProtocol.body)
		#expect(progress.first == .init(direction: .request, completedByteCount: 0, expectedByteCount: 0))
		#expect(progress.first?.fractionCompleted == 1)
		#expect(progress.contains(.init(direction: .response, completedByteCount: 1024, expectedByteCount: 2048)))
		#expect(progress.last == .init(direction: .response, completedByteCount: 2048, expectedByteCount: 2048))
		#expect(progress.last?.fractionCompleted == 1)
	}
}

// MARK: - StubURLProtocol

private final class StubURLProtocol: URLProtocol {
	static let body = Data(repeating: 0x61, count: 2048)

	override static func canInit(with request: URLRequest) -> Bool { true }

	override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		let headers = ["Content-Length": "\(Self.body.count)"]
		guard let url = request.url,
			  let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers) else {
			client?.urlProtocol(self, didFailWithError: URLError(.badURL))
			return
		}
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		client?.urlProtocol(self, didLoad: Self.body)
		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() { }
}
