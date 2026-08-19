//
//  ProductDetailVMTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import NetworkKit
@testable import BipCaseStudy

@MainActor
final class ProductDetailVMTests: XCTestCase {

    private var sut: ProductDetailVM!
    private var mockUseCase: MockProductUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockProductUseCase()
        sut = ProductDetailVM(productId: "1", useCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadDetail_success() async {
        // Given
        mockUseCase.mockProductDetail = .success(MockData.sampleProductDetail)

        // When
        await sut.loadDetail()

        // Then
        XCTAssertNotNil(sut.productDetail)
        XCTAssertEqual(sut.productDetail?.name, "Apples")
        XCTAssertEqual(sut.productDetail?.description, "An apple a day keeps the doctor away.")
        XCTAssertEqual(sut.pageState, .content)
    }

    func test_loadDetail_failure() async {
        // Given
        mockUseCase.mockProductDetail = .failure(NetworkError(ResponseErrorType.notFound))

        // When
        await sut.loadDetail()

        // Then
        XCTAssertNil(sut.productDetail)
        XCTAssertEqual(sut.pageState, .noContent)
        XCTAssertNotNil(sut.emptyModel)
    }
}
