//
//  ServerTrustPolicy.swift
//  PortainerKit
//
//  Created by royal on 19/10/2026.
//  Copyright © 2026 shameful. All rights reserved.
//

import CryptoKit
import Foundation

// MARK: - ServerTrustPolicy

/// Decides whether a server certificate that failed system trust evaluation (e.g. a self-signed one) should be accepted.
public struct ServerTrustPolicy: Sendable {
	public typealias Evaluator = @Sendable (_ host: String, _ port: Int, _ certificateFingerprint: String) -> Bool

	/// Called with the host, port and SHA-256 fingerprint (lowercase hex) of the leaf certificate.
	public let isTrusted: Evaluator

	public init(isTrusted: @escaping Evaluator) {
		self.isTrusted = isTrusted
	}
}

// MARK: - ServerTrustPolicy+Static

public extension ServerTrustPolicy {
	/// Accepts only certificates trusted by the system.
	static let system = ServerTrustPolicy { _, _, _ in false }

	/// Returns the SHA-256 fingerprint (lowercase hex) of the leaf certificate in `trust`.
	static func certificateFingerprint(of trust: SecTrust) -> String? {
		guard let leaf = (SecTrustCopyCertificateChain(trust) as? [SecCertificate])?.first else { return nil }
		let data = SecCertificateCopyData(leaf) as Data
		return SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
	}

	/// Returns the SHA-256 fingerprint of the untrusted server certificate that caused `error`, if any.
	static func untrustedCertificateFingerprint(from error: any Error) -> String? {
		var nsError: NSError? = error as NSError
		while let current = nsError {
			if let value = current.userInfo[NSURLErrorFailingURLPeerTrustErrorKey] as AnyObject?,
			   CFGetTypeID(value) == SecTrustGetTypeID() {
				return certificateFingerprint(of: unsafeDowncast(value, to: SecTrust.self))
			}
			nsError = current.userInfo[NSUnderlyingErrorKey] as? NSError
		}
		return nil
	}
}
