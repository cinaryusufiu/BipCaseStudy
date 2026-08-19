//
//  HeaderManager.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Token Provider

public struct TokenProvider: Sendable {
    public let accessToken: String
    public let tokenType: String

    public init(accessToken: String, tokenType: String = "Bearer") {
        self.accessToken = accessToken
        self.tokenType = tokenType
    }
}

// MARK: - Protocol

public protocol HeaderManagerProtocol: Sendable {
    func defaultHeaders(for context: EndpointContext) -> [String: String]
    func authorizationHeaders() -> [String: String]
    func setTokenProvider(_ provider: TokenProvider?)
    func setHeader(_ value: String, forKey key: String)
    func removeHeader(forKey key: String)
}

// MARK: - Implementation

public final class HeaderManager: HeaderManagerProtocol, @unchecked Sendable {

    private var customHeaders: [String: String] = [:]
    private var tokenProvider: TokenProvider?

    public init() {}
}

// MARK: - Token Management

extension HeaderManager {

    public func setTokenProvider(_ provider: TokenProvider?) {
        self.tokenProvider = provider
    }
}

// MARK: - Header Management

extension HeaderManager {

    public func setHeader(_ value: String, forKey key: String) {
        customHeaders[key] = value
    }

    public func removeHeader(forKey key: String) {
        customHeaders.removeValue(forKey: key)
    }
}

// MARK: - HeaderManagerProtocol

extension HeaderManager {

    public func defaultHeaders(for context: EndpointContext) -> [String: String] {
        var headers: [String: String] = [
            "Accept": "application/json"
        ]
        customHeaders.forEach { headers[$0.key] = $0.value }
        return headers
    }

    public func authorizationHeaders() -> [String: String] {
        var headers = defaultHeaders(for: .api)
        if let provider = tokenProvider {
            headers["Authorization"] = "\(provider.tokenType) \(provider.accessToken)"
        }
        return headers
    }
}
