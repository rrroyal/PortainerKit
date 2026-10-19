//
//  PortainerClient+URLSessionDelegate.swift
//  PortainerKit
//
//  Created by royal on 17/10/2021.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

internal extension PortainerClient {
	final class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate, Sendable {
		private let serverTrustPolicy: ServerTrustPolicy

		init(serverTrustPolicy: ServerTrustPolicy) {
			self.serverTrustPolicy = serverTrustPolicy
		}

		func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
			let protectionSpace = challenge.protectionSpace
			guard protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
				  let trust = protectionSpace.serverTrust else {
				return (.performDefaultHandling, nil)
			}

			if SecTrustEvaluateWithError(trust, nil) {
				return (.performDefaultHandling, nil)
			}

			if let fingerprint = ServerTrustPolicy.certificateFingerprint(of: trust),
			   serverTrustPolicy.isTrusted(protectionSpace.host, protectionSpace.port, fingerprint) {
				return (.useCredential, URLCredential(trust: trust))
			}

			return (.performDefaultHandling, nil)
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
