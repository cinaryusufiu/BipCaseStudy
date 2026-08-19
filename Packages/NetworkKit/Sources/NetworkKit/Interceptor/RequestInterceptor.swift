//
//  RequestInterceptor.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol RequestInterceptorProtocol {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}

// MARK: - Logging Interceptor

public final class LoggingInterceptor: RequestInterceptorProtocol {
    private let logger: NetworkLogger

    public init(logger: NetworkLogger = NetworkLogger()) {
        self.logger = logger
    }

    public func intercept(_ request: URLRequest) async throws -> URLRequest {
        logger.logRequest(request, body: request.httpBody)
        return request
    }
}
