//
//  MockNetworkSession.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

final class MockNetworkSession: NetworkSessionProtocol, @unchecked Sendable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError { throw error }

        let data = mockData ?? Data()
        let response = mockResponse ?? makeResponse(url: request.url, statusCode: 200)
        return (data, response)
    }

    func configure(statusCode: Int, data: Data) {
        self.mockData = data
        self.mockResponse = makeResponse(url: URL(string: "https://example.com"), statusCode: statusCode)
    }

    // MARK: - Private

    private func makeResponse(url: URL?, statusCode: Int) -> HTTPURLResponse {
        guard let url,
              let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
            fatalError("Failed to create HTTPURLResponse")
        }
        return response
    }
}
