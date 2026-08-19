//
//  ProductListVMTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import NetworkKit
@testable import BipCaseStudy

@MainActor
final class ProductListVMTests: XCTestCase {

    private var sut: ProductListVM!
    private var mockUseCase: MockProductUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockProductUseCase()
        sut = ProductListVM(useCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadProducts_success() async {
        // Given
        mockUseCase.mockProducts = .success(MockData.sampleProducts)

        // When
        await sut.loadProducts()

        // Then
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(sut.pageState, .content)
    }

    func test_loadProducts_emptyResult() async {
        // Given
        mockUseCase.mockProducts = .success([])

        // When
        await sut.loadProducts()

        // Then
        XCTAssertTrue(sut.products.isEmpty)
        XCTAssertEqual(sut.pageState, .noContent)
    }

    func test_loadProducts_failure_showsError() async {
        // Given
        mockUseCase.mockProducts = .failure(NetworkError(ServerErrorType(statusCode: 500)))

        // When
        await sut.loadProducts()

        // Then
        XCTAssertEqual(sut.pageState, .noContent)
        XCTAssertNotNil(sut.emptyModel)
    }
}
