//
//  WebSocketMessage.swift
//  PortainerKit
//
//  Created by royal on 13/06/2021.
//  Copyright © 2024 shameful. All rights reserved.
//

import Combine
import Foundation

public typealias WebSocketPassthroughSubject = PassthroughSubject<WebSocketMessage, Error>

public struct WebSocketMessage: Sendable {
	public enum MessageSource: Sendable {
		case server, client
	}

	public let message: URLSessionWebSocketTask.Message
	public let source: MessageSource
}
