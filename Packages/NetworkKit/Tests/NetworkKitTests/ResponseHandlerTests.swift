//
//  ResponseHandlerTests.swift
//  NetworkKitTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import NetworkKit

final class ResponseHandlerTests: XCTestCase {

    private var sut: DefaultResponseHandler!

    override func setUp() {
        super.setUp()
        sut = DefaultResponseHandler()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_handle_success() throws {
        // Given
        let json = """
        {"id": 1, "title": "Test"}
        """.data(using: .utf8)!

        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When
        let result: TestItem = try sut.handle(data: json, response: response)

        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "Test")
    }

    func test_handle_snakeCaseDecoding() throws {
        // Given
        let json = """
        {"user_name": "Yusuf", "created_at": "2026-08-17"}
        """.data(using: .utf8)!

        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When
        let result: SnakeCaseModel = try sut.handle(data: json, response: response)

        // Then
        XCTAssertEqual(result.userName, "Yusuf")
        XCTAssertEqual(result.createdAt, "2026-08-17")
    }

    func test_handle_httpError_401() {
        // Given
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )!

        // Then
        XCTAssertThrowsError(
            try sut.handle(data: Data(), response: response) as TestItem
        ) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError(ResponseErrorType.unauthorized))
        }
    }

    func test_handle_httpError_500() {
        // Given
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        // Then
        XCTAssertThrowsError(
            try sut.handle(data: Data(), response: response) as TestItem
        ) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError(ServerErrorType(statusCode: 500)))
        }
    }

    func test_handle_invalidResponse() {
        // Given
        let response = URLResponse()

        // Then
        XCTAssertThrowsError(
            try sut.handle(data: Data(), response: response) as TestItem
        ) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError(ResponseErrorType.invalidResponse))
        }
    }

    func test_handle_decodingError() {
        // Given
        let invalidJSON = "not json".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // Then
        XCTAssertThrowsError(
            try sut.handle(data: invalidJSON, response: response) as TestItem
        ) { error in
            XCTAssertEqual(error as? NetworkError, NetworkError(ClientErrorType.decodingError))
        }
    }
}

// MARK: - Test Helpers

private struct TestItem: Codable, Equatable {
    let id: Int
    let title: String
}

private struct SnakeCaseModel: Codable, Equatable {
    let userName: String
    let createdAt: String
}
