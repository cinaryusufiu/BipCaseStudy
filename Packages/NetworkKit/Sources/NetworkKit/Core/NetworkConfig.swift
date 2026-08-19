//
//  NetworkConfig.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public struct NetworkConfig: Sendable {

    public let baseURL: URL
    public let timeoutInterval: TimeInterval

    public init(baseURL: URL, timeoutInterval: TimeInterval = 30) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
    }
}
