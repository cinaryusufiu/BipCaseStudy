//
//  ResponseErrorType.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public enum ResponseErrorType: String, NetworkErrorConvertible {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case noData

    public var statusCode: Int? {
        switch self {
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .invalidResponse, .noData: return nil
        }
    }

    public var message: String {
        switch self {
        case .invalidResponse: return "Invalid server response"
        case .unauthorized: return "Unauthorized access"
        case .forbidden: return "Access forbidden"
        case .notFound: return "Resource not found"
        case .noData: return "No data received"
        }
    }

    public var userFacingMessage: String {
        switch self {
        case .notFound: return "The requested content was not found."
        default: return "Something went wrong. Please try again."
        }
    }
}
