//
//  ClientErrorType.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public enum ClientErrorType: String, NetworkErrorConvertible {
    case configurationError
    case decodingError
    case networkError

    public var message: String {
        switch self {
        case .configurationError: return "Network configuration error"
        case .decodingError: return "Failed to decode response"
        case .networkError: return "Network error occurred"
        }
    }
}
