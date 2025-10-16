import Foundation
import NetworkKit
@testable import PortainerKit
import Testing

@Suite
struct RequestTests {
	// swiftlint:disable:next force_unwrapping
	private static let serverURL = URL(string: "http://localhost:9443")!
	private static let endpointID: Endpoint.ID = 0
	private static let containerID: Container.ID = ":containerID"
	private static let stackID: Stack.ID = 0

	@Test(arguments: [
		ContainerActionRequest(containerID: containerID, endpointID: endpointID, action: .kill, signal: nil) as NetworkRequest,
		ContainerDetailsRequest(containerID: containerID, endpointID: endpointID),
		ContainerLogsRequest(containerID: containerID, endpointID: endpointID, stdout: true, tailAmount: 100),
		ContainersRequest(endpointID: endpointID, filters: .init(name: ["some_container"])),
		EndpointsRequest(),
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
		StackRequest(stackID: stackID),
		StackFileRequest(stackID: stackID),
		StackRemoveRequest(stackID: stackID, endpointID: endpointID),
		StackSetStateRequest(stackID: stackID, started: true, endpointID: endpointID),
		StacksRequest(),
		StackUpdateRequest(stackID: stackID, endpointID: endpointID, settings: .init(env: [], prune: true, pullImage: true, stackFileContent: ""))
	])
	func `Describe requests`(_ request: any NetworkRequest) throws {
		let description = try description(for: request)
		print(description)
	}
}

private extension RequestTests {
	func description<R: NetworkRequest>(for networkRequest: R) throws -> String {
		var description: [String] = []

		description.append("\(networkRequest)")

		let request = try networkRequest.urlRequest(baseURL: Self.serverURL)

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
}
