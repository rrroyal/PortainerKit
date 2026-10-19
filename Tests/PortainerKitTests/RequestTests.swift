import Foundation
import NetworkKit
@testable import PortainerKit
import Testing

@Suite
struct RequestTests {
	// swiftlint:disable:next force_unwrapping
	private static let serverURL = URL(string: "http://localhost:9443")!
	private static let endpointID: Endpoint.ID = 42
	private static let containerID: Container.ID = ":containerID"
	private static let stackID: Stack.ID = 0

	@Test(.tags(.networkRequest, .stacks))
	func `Stack management requests include endpoint ID query item`() throws {
		let startRequest = try StackSetStateRequest(stackID: Self.stackID, started: true, endpointID: Self.endpointID)
			.urlRequest(baseURL: Self.serverURL)
		let updateRequest = try StackUpdateRequest(
			stackID: Self.stackID,
			endpointID: Self.endpointID,
			settings: .init(env: [], prune: true, pullImage: false, stackFileContent: "")
		).urlRequest(baseURL: Self.serverURL)
		let removeRequest = try StackRemoveRequest(stackID: Self.stackID, endpointID: Self.endpointID)
			.urlRequest(baseURL: Self.serverURL)

		#expect(startRequest.url?.query?.contains("endpointId=") == true)
		#expect(updateRequest.url?.query?.contains("endpointId=") == true)
		#expect(removeRequest.url?.query?.contains("endpointId=") == true)
	}

	@Test(.tags(.networkRequest, .stacks, .regression))
	func `Stack management requests preserve provided endpoint ID`() throws {
		let endpointID: Endpoint.ID = 999
		let startRequest = try StackSetStateRequest(stackID: Self.stackID, started: true, endpointID: endpointID)
			.urlRequest(baseURL: Self.serverURL)
		let updateRequest = try StackUpdateRequest(
			stackID: Self.stackID,
			endpointID: endpointID,
			settings: .init(env: [], prune: true, pullImage: false, stackFileContent: "")
		).urlRequest(baseURL: Self.serverURL)
		let removeRequest = try StackRemoveRequest(stackID: Self.stackID, endpointID: endpointID)
			.urlRequest(baseURL: Self.serverURL)

		#expect(startRequest.url?.absoluteString == "http://localhost:9443/api/stacks/0/start?endpointId=999")
		#expect(updateRequest.url?.absoluteString == "http://localhost:9443/api/stacks/0?endpointId=999")
		#expect(removeRequest.url?.absoluteString == "http://localhost:9443/api/stacks/0?endpointId=999")
	}

	@Test(.tags(.networkRequest, .stacks, .regression))
	func `Stacks request only includes orphaned stacks with an endpoint filter`() throws {
		let unfiltered = try StacksRequest(endpointID: nil, includeOrphanedStacks: true).urlRequest(baseURL: Self.serverURL)
		let filtered = try StacksRequest(endpointID: Self.endpointID, includeOrphanedStacks: true).urlRequest(baseURL: Self.serverURL)

		#expect(unfiltered.url?.query?.contains("includeOrphanedStacks") == false)
		#expect(filtered.url?.query?.contains("includeOrphanedStacks") == true)
	}

	@Test(.tags(.networkRequest, .containers))
	func `Container action requests have no body`() throws {
		let request = try ContainerActionRequest(containerID: Self.containerID, endpointID: Self.endpointID, action: .start)
			.urlRequest(baseURL: Self.serverURL)

		#expect(request.httpMethod == "POST")
		#expect(request.httpBody == nil)
	}
}
