//
//  NetworkClientTests.swift
//  NetworkKitTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import NetworkKit

final class NetworkClientTests: XCTestCase {

    private var sut: NetworkClient!
    private var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        sut = NetworkClient(
            session: mockSession,
            requestBuilder: DefaultRequestBuilder(),
            responseHandler: DefaultResponseHandler(),
            interceptors: []
        )
        sut.configure(with: NetworkConfig(
            baseURL: URL(string: "https://example.com")!
        ))
    }

    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_execute_success() async {
        // Given
        let jsonData = """
        {"name": "Test", "value": 42}
        """.data(using: .utf8)!

        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let endpoint = Endpoint<TestModel>(path: "/test")

        // When
        let result = await sut.execute(endpoint)

        // Then
        switch result {
        case .success(let model):
            XCTAssertEqual(model.name, "Test")
            XCTAssertEqual(model.value, 42)
        case .failure(let error):
            XCTFail("Expected success, got \(error)")
        }
    }

    func test_execute_httpError() async {
        // Given
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com/test")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )

        let endpoint = Endpoint<TestModel>(path: "/test")

        // When
        let result = await sut.execute(endpoint)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ResponseErrorType.notFound))
        }
    }

    func test_execute_decodingError() async {
        // Given
        let invalidJSON = "not json".data(using: .utf8)!
        mockSession.mockData = invalidJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let endpoint = Endpoint<TestModel>(path: "/test")

        // When
        let result = await sut.execute(endpoint)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ClientErrorType.decodingError))
        }
    }

    func test_execute_noConfig() async {
        // Given
        let client = NetworkClient(session: mockSession, interceptors: [])
        let endpoint = Endpoint<TestModel>(path: "/test")

        // When
        let result = await client.execute(endpoint)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ClientErrorType.configurationError))
        }
    }

    func test_execute_withFullURL() async {
        // Given
        let jsonData = """
        {"name": "FullURL", "value": 1}
        """.data(using: .utf8)!

        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://other.com/data")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let endpoint = Endpoint<TestModel>(
            fullURL: "https://other.com/data"
        )

        // When
        let result = await sut.execute(endpoint)

        // Then
        switch result {
        case .success(let model):
            XCTAssertEqual(model.name, "FullURL")
        case .failure(let error):
            XCTFail("Expected success, got \(error)")
        }
    }
}

// MARK: - Test Helpers

private struct TestModel: Codable, Equatable {
    let name: String
    let value: Int
}

private final class MockSession: NetworkSessionProtocol, @unchecked Sendable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError { throw error }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}
