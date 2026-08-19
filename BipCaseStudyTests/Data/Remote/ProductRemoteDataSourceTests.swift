//
//  ProductRemoteDataSourceTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import NetworkKit
@testable import BipCaseStudy

final class ProductRemoteDataSourceTests: XCTestCase {

    private var sut: ProductRemoteDataSource!
    private var mockNetworkClient: MockNetworkClient!

    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = ProductRemoteDataSource(networkClient: mockNetworkClient)
    }

    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        super.tearDown()
    }

    // MARK: - Fetch Products

    func test_fetchProducts_success_returnsProductArray() async {
        // Given
        mockNetworkClient.setSuccess(MockData.sampleProductListResponse)

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(products.first?.name, "Apples")
            XCTAssertEqual(mockNetworkClient.executeCallCount, 1)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProducts_failure_propagatesError() async {
        // Given
        mockNetworkClient.setFailure(
            NetworkError(ServerErrorType(statusCode: 500)),
            type: ProductListResponse.self
        )

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ServerErrorType(statusCode: 500)))
        }
    }

    // MARK: - Fetch Product Detail

    func test_fetchProductDetail_success() async {
        // Given
        mockNetworkClient.setSuccess(MockData.sampleProductDetail)

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Apples")
            XCTAssertEqual(detail.description, "An apple a day keeps the doctor away.")
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProductDetail_failure() async {
        // Given
        mockNetworkClient.setFailure(
            NetworkError(ResponseErrorType.notFound),
            type: ProductDetail.self
        )

        // When
        let result = await sut.fetchProductDetail(id: "999")

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ResponseErrorType.notFound))
        }
    }

    // MARK: - Save (No-op)

    func test_saveOperations_areNoOp() {
        // No-op for remote - should not crash
        sut.saveProducts(MockData.sampleProducts)
        sut.saveProductDetail(MockData.sampleProductDetail)
        sut.clearAll()
    }
}
