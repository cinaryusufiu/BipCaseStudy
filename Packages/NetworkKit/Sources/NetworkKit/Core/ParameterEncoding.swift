//
//  ParameterEncoding.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol ParameterEncoding: Sendable {
    func encode(_ parameters: [String: Any]) throws -> Data?
}

// MARK: - JSON Encoding

public struct JSONEncoding: ParameterEncoding {

    public static let `default` = JSONEncoding()

    public func encode(_ parameters: [String: Any]) throws -> Data? {
        try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

// MARK: - URL Encoding

public struct URLEncoding: ParameterEncoding {

    public static let `default` = URLEncoding()

    public func encode(_ parameters: [String: Any]) throws -> Data? {
        var components = URLComponents()
        components.queryItems = parameters
            .sorted { $0.key < $1.key }
            .map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        return components.percentEncodedQuery?.data(using: .utf8)
    }
}
