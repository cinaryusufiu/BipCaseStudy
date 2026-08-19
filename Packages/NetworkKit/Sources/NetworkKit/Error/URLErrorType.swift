//
//  URLErrorType.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public enum URLErrorType: String, NetworkErrorConvertible {
    case invalidURL
    case noInternetConnection
    case timeout

    public var message: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noInternetConnection: return "No internet connection"
        case .timeout: return "Request timed out"
        }
    }

    public var userFacingMessage: String {
        switch self {
        case .invalidURL: return "Something went wrong. Please try again."
        case .noInternetConnection: return "Please check your internet connection and try again."
        case .timeout: return "The request timed out. Please try again."
        }
    }
}
