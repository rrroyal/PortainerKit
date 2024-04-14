import NetworkKit
@testable import PortainerKit
import XCTest

final class OfflineTests: XCTestCase {
	// swiftlint:disable:next force_unwrapping
	let serverURL = URL(string: "http://localhost:9443")!
	let endpointID: Endpoint.ID = 0
	let containerID: Container.ID = ":containerID"
	let stackID: Stack.ID = 0

	private func description<R: NetworkRequest>(for networkRequest: R) throws -> String {
		var description: [String] = []

		description.append("\(networkRequest)")

		let request = try networkRequest.urlRequest(baseURL: serverURL)

		description.append("URL:\t\t\(request.url?.absoluteString ?? "<nil>")")
		description.append("Method:\t\t\(request.httpMethod ?? "<nil>")")

		if let body = request.httpBody {
			let readableBody: String = if let string = String(data: body, encoding: .ascii) {
				string
			} else {
				body.base64EncodedString()
			}
			description.append("Body:\t\t\(readableBody)")
		}

		if let query = request.url?.query() {
			description.append("Query:\t\t\(query)")
		}

		if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
			description.append("Headers:\t\(headers)")
		}

		return description.joined(separator: "\n")
	}

	func testRequests() throws {
		print("--- Requests ---\n")

		let requests: [any NetworkRequest] = [
			ContainerActionRequest(containerID: containerID, endpointID: endpointID, action: .kill, signal: nil),
			ContainerDetailsRequest(containerID: containerID, endpointID: endpointID),
			ContainerLogsRequest(containerID: containerID, endpointID: endpointID, stdout: true, tailAmount: 100),
			ContainersRequest(endpointID: endpointID, filters: .init(name: ["some_container"])),
			EndpointsRequest(),
			StackSetStatusRequest(stackID: stackID, started: true, endpointID: endpointID),
			StackDeployRequest(
				endpointID: endpointID,
				settings: StackDeployment.DeploymentSettings.StandaloneString(
					env: [
						"KEY": "VALUE"
					],
					name: "stackName",
					stackFileContent: "stackFileContent"
				)
			),
			StackDetailsRequest(stackID: stackID),
			StacksRequest()
		]

		let descriptions = try requests.map {
			try description(for: $0)
		}

		print(descriptions.joined(separator: "\n\n"), "\n")
	}
}
