import Foundation
@testable import PortainerKit
import Testing

@Suite(.tags(.networking, .stacks))
struct TransferProgressTests {
	@Test
	func `Stack deployment reports request and response progress`() async throws {
		let responseData = Data(#"{"Id":1,"Name":"demo","Type":2,"EndpointId":42}"#.utf8)
		let session = MockPortainerURLSession(behavior: .respond(data: responseData))
		let client = PortainerClient._forTests(
			serverURL: URL(string: "https://portainer.example.com"),
			token: "token",
			urlSession: session
		)
		let recorder = ProgressRecorder()
		let settings = StackDeployment.DeploymentSettings.StandaloneString(
			name: "demo",
			stackFileContent: "services: {}"
		)

		_ = try await client.deployStack(endpointID: 42, settings: settings) { progress in
			Task { await recorder.append(progress) }
		}

		await recorder.waitForCount(2)
		let values = await recorder.values
		#expect(values.contains { $0.direction == .request && $0.fractionCompleted == 1 })
		#expect(values.contains { $0.direction == .response && $0.fractionCompleted == 1 })
	}
}

private actor ProgressRecorder {
	private(set) var values: [TransferProgress] = []

	func append(_ progress: TransferProgress) {
		values.append(progress)
	}

	func waitForCount(_ count: Int) async {
		while values.count < count {
			await Task.yield()
		}
	}
}
