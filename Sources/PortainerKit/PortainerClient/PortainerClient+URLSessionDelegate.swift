//
//  PortainerClient+URLSessionDelegate.swift
//  PortainerKit
//
//  Created by royal on 17/10/2021.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

internal extension PortainerClient {
	final class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {
		func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
			if let trust = challenge.protectionSpace.serverTrust {
				return (.useCredential, URLCredential(trust: trust))
			} else {
				return (.useCredential, nil)
			}
		}
	}

	final class TransferProgressDelegate: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
		private let progressHandler: TransferProgressHandler

		init(progressHandler: @escaping TransferProgressHandler) {
			self.progressHandler = progressHandler
		}

		func urlSession(
			_ session: URLSession,
			task: URLSessionTask,
			didSendBodyData bytesSent: Int64,
			totalBytesSent: Int64,
			totalBytesExpectedToSend: Int64
		) {
			progressHandler(.init(
				direction: .request,
				completedByteCount: totalBytesSent,
				expectedByteCount: totalBytesExpectedToSend > 0 ? totalBytesExpectedToSend : nil
			))
		}
	}
}
