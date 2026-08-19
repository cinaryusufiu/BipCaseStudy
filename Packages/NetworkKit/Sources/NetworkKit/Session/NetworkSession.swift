//
//  NetworkSession.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol NetworkSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Adapter

public final class URLSessionAdapter: NetworkSessionProtocol {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
