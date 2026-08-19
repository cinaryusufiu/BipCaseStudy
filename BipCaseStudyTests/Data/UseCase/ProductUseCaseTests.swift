//
//  ProductUseCaseTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import NetworkKit
@testable import BipCaseStudy

final class ProductUseCaseTests: XCTestCase {

    private var sut: ProductUseCase!
    private var mockRepository: MockProductRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductRepository()
        sut = ProductUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Fetch Products

    func test_fetchProducts_success() async {
        // Given
        mockRepository.mockProducts = .success(MockData.sampleProducts)

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(mockRepository.fetchProductsCallCount, 1)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProducts_failure() async {
        // Given
        mockRepository.mockProducts = .failure(NetworkError(ServerErrorType(statusCode: 500)))

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
        mockRepository.mockProductDetail = .success(MockData.sampleProductDetail)

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Apples")
            XCTAssertEqual(detail.description, "An apple a day keeps the doctor away.")
            XCTAssertEqual(mockRepository.fetchProductDetailCallCount, 1)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProductDetail_failure() async {
        // Given
        mockRepository.mockProductDetail = .failure(NetworkError(ResponseErrorType.notFound))

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
}
