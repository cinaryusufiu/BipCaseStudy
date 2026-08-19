//
//  RequestBuilderTests.swift
//  NetworkKitTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import NetworkKit

final class RequestBuilderTests: XCTestCase {

    private var sut: DefaultRequestBuilder!
    private let config = NetworkConfig(baseURL: URL(string: "https://api.example.com")!)

    override func setUp() {
        super.setUp()
        sut = DefaultRequestBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_buildRequest_withPath() throws {
        // Given
        let endpoint = Endpoint<EmptyResponse>(path: "/products")

        // When
        let request = try sut.buildRequest(from: endpoint, config: config)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/products")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_buildRequest_withFullURL() throws {
        // Given
        let endpoint = Endpoint<EmptyResponse>(
            fullURL: "https://s3.amazonaws.com/test/data"
        )

        // When
        let request = try sut.buildRequest(from: endpoint, config: config)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://s3.amazonaws.com/test/data")
    }

    func test_buildRequest_withPOSTBody() throws {
        // Given
        let endpoint = Endpoint<EmptyResponse>(
            path: "/create",
            method: .post,
            parameters: ["name": "test", "value": 42]
        )

        // When
        let request = try sut.buildRequest(from: endpoint, config: config)

        // Then
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func test_buildRequest_withCustomHeaders() throws {
        // Given
        let endpoint = Endpoint<EmptyResponse>(
            path: "/data",
            headers: ["X-Custom": "value"]
        )

        // When
        let request = try sut.buildRequest(from: endpoint, config: config)

        // Then
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Custom"), "value")
    }

    func test_buildRequest_invalidFullURL() {
        // Given
        let endpoint = Endpoint<EmptyResponse>(
            fullURL: ""
        )

        // Then
        XCTAssertThrowsError(try sut.buildRequest(from: endpoint, config: config))
    }

    func test_buildRequest_timeout() throws {
        // Given
        let customConfig = NetworkConfig(baseURL: URL(string: "https://api.example.com")!, timeoutInterval: 45)
        let endpoint = Endpoint<EmptyResponse>(path: "/test")

        // When
        let request = try sut.buildRequest(from: endpoint, config: customConfig)

        // Then
        XCTAssertEqual(request.timeoutInterval, 45)
    }
}

private struct EmptyResponse: Codable {}
