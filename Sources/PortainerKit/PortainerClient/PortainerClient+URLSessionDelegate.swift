//
//  PortainerClient+URLSessionDelegate.swift
//  PortainerKit
//
//  Created by royal on 17/10/2021.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

internal extension PortainerClient {
	final class URLSessionDelegate: NSObject, URLSessionTaskDelegate, Sendable {
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

		/// Only follows redirects to the same origin, so the API key isn't sent to other servers.
		func urlSession(
			_ session: URLSession,
			task: URLSessionTask,
			willPerformHTTPRedirection response: HTTPURLResponse,
			newRequest request: URLRequest
		) async -> URLRequest? {
			guard let originalURL = task.originalRequest?.url, let newURL = request.url else { return nil }
			let isSameOrigin = originalURL.scheme?.lowercased() == newURL.scheme?.lowercased()
				&& originalURL.host()?.lowercased() == newURL.host()?.lowercased()
				&& originalURL.port == newURL.port
			return isSameOrigin ? request : nil
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
