//
//  JSONDecoder+portainer.swift
//  PortainerKit
//
//  Created by royal on 14/04/2024.
//  Copyright © 2024 shameful. All rights reserved.
//

import Foundation

extension JSONDecoder {
	static let portainer: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .custom { decoder -> Date in
			let dateFormatter = ISO8601DateFormatter()

			let container = try decoder.singleValueContainer()
			do {
				let str = try container.decode(String.self)

				dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
				if let date = dateFormatter.date(from: str) { return date }

				dateFormatter.formatOptions = [.withInternetDateTime]
				if let date = dateFormatter.date(from: str) { return date }

				throw DateError.invalidDate(dateString: str)
			} catch {
				if error is DecodingError {
					let number = try container.decode(TimeInterval.self)
					return Date(timeIntervalSince1970: number)
				}

				throw error
			}
		}
		return decoder
	}()
}
