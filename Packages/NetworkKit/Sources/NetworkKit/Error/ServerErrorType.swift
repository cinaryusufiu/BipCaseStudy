//
//  ServerErrorType.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public struct ServerErrorType: NetworkErrorConvertible {

    public let statusCode: Int?

    public init(statusCode: Int) {
        self.statusCode = statusCode
    }

    public var code: String { "serverError" }

    public var message: String {
        "Server error: \(statusCode ?? 0)"
    }

    public var userFacingMessage: String {
        "Server is temporarily unavailable. Please try again later."
    }
}

public struct HTTPErrorType: NetworkErrorConvertible {

    public let statusCode: Int?

    public init(statusCode: Int) {
        self.statusCode = statusCode
    }

    public var code: String { "httpError" }

    public var message: String {
        "HTTP error: \(statusCode ?? 0)"
    }
}
