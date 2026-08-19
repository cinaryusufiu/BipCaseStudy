//
//  MockNetworkClient.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit
@testable import BipCaseStudy

final class MockNetworkClient: NetworkClientProtocol {

    var mockResult: Any?
    var executeCallCount = 0
    var configureCallCount = 0

    func configure(with config: NetworkConfig) {
        configureCallCount += 1
    }

    func execute<T: Decodable>(_ endpoint: Endpoint<T>) async -> Result<T, NetworkError> {
        executeCallCount += 1
        if let result = mockResult as? Result<T, NetworkError> {
            return result
        }
        return .failure(NetworkError(ResponseErrorType.noData))
    }

    func setSuccess<T: Decodable>(_ value: T) {
        mockResult = Result<T, NetworkError>.success(value)
    }

    func setFailure<T: Decodable>(_ error: NetworkError, type: T.Type) {
        mockResult = Result<T, NetworkError>.failure(error)
    }
}
