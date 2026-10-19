//
//  ServerTrustPolicyTests.swift
//  PortainerKitTests
//
//  Created by royal on 19/10/2026.
//

import Foundation
import PortainerKit
import Testing

@Suite
struct ServerTrustPolicyTests {
	/// Self-signed certificate for "portainer.test".
	private static let certificateBase64 = """
		MIIBaDCCAQ6gAwIBAgIUUp27gKb9LsAuXKkh5memE7PxMUYwCgYIKoZIzj0EAwIwGTEXMBUGA1UEAwwOcG9ydGFpbmVyLnRlc3QwIBcNMjYxMDE5MTcyOTAzWhgPMjEyNjA5MjUxNzI5MDNaMBkxFzAVBgNV
		BAMMDnBvcnRhaW5lci50ZXN0MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEV2I0vB0FDMxHLw3mUDKwrWOS0dnKWj/foQ75P63wFfoyHbQ/Q0Eorru8NXMS8ZW5GhxZr2Cv7aSi2gis3l2HTKMyMDAwHQYD
		VR0OBBYEFCBRWMDKZGdW5bQ2nIdxUUyxGGzMMA8GA1UdEwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSAAwRQIhAN/N62O4jq5z77Oe3wsK956QbY95n5/9mLkaAzOzh6fHAiA0dJAYmTGVNkgicTII2+q4xLTIii77
		sf3nR6vGyYntSA==
		"""
	/// `openssl x509 -noout -fingerprint -sha256`
	private static let expectedFingerprint = "65bde1affb21df9c3df23a415c7f66b608ff5b746cbf0e13fd1e1a5df7c0f936"

	private static func makeTrust() throws -> SecTrust {
		let data = try #require(Data(base64Encoded: certificateBase64, options: .ignoreUnknownCharacters))
		let certificate = try #require(SecCertificateCreateWithData(nil, data as CFData))
		var trust: SecTrust?
		SecTrustCreateWithCertificates(certificate, SecPolicyCreateSSL(true, "portainer.test" as CFString), &trust)
		return try #require(trust)
	}

	@Test
	func `Fingerprint is SHA-256 of the leaf certificate`() throws {
		#expect(ServerTrustPolicy.certificateFingerprint(of: try Self.makeTrust()) == Self.expectedFingerprint)
	}

	@Test
	func `Fingerprint is read from untrusted certificate errors`() throws {
		let trust = try Self.makeTrust()
		let underlying = NSError(domain: NSURLErrorDomain, code: URLError.serverCertificateUntrusted.rawValue, userInfo: [
			NSURLErrorFailingURLPeerTrustErrorKey: trust
		])
		let wrapped = URLError(.secureConnectionFailed, userInfo: [NSUnderlyingErrorKey: underlying])

		#expect(ServerTrustPolicy.untrustedCertificateFingerprint(from: underlying) == Self.expectedFingerprint)
		#expect(ServerTrustPolicy.untrustedCertificateFingerprint(from: wrapped) == Self.expectedFingerprint)
		#expect(ServerTrustPolicy.untrustedCertificateFingerprint(from: URLError(.timedOut)) == nil)
	}
}
