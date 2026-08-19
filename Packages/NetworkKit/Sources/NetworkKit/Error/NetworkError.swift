//
//  NetworkError.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol NetworkErrorConvertible: Error, Sendable {
    var code: String { get }
    var statusCode: Int? { get }
    var message: String { get }
    var userFacingMessage: String { get }
}

// MARK: - Default Implementations

extension NetworkErrorConvertible where Self: RawRepresentable, Self.RawValue == String {

    public var code: String { rawValue }
}

extension NetworkErrorConvertible {

    public var statusCode: Int? { nil }

    public var userFacingMessage: String {
        "Something went wrong. Please try again."
    }
}

// MARK: - Concrete Wrapper

public struct NetworkError: Error, Equatable, Sendable {

    public let code: String
    public let statusCode: Int?
    public let message: String
    public let userFacingMessage: String

    public init(_ error: any NetworkErrorConvertible, message: String? = nil) {
        self.code = error.code
        self.statusCode = error.statusCode
        self.message = message ?? error.message
        self.userFacingMessage = error.userFacingMessage
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.code == rhs.code && lhs.statusCode == rhs.statusCode
    }
}
