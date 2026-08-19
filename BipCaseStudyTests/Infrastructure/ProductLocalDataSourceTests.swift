//
//  ProductLocalDataSourceTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import CoreData
import NetworkKit
@testable import BipCaseStudy

final class ProductLocalDataSourceTests: XCTestCase {

    private var sut: ProductLocalDataSource!
    private var coreDataStack: CoreDataStackProtocol!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true)
        sut = ProductLocalDataSource(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        sut = nil
        coreDataStack = nil
        super.tearDown()
    }

    func test_saveAndFetchProducts() async {
        // Given
        let products = MockData.sampleProducts

        // When
        sut.saveProducts(products)
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let cached):
            XCTAssertEqual(cached.count, 2)
            XCTAssertTrue(cached.contains(where: { $0.name == "Apples" }))
            XCTAssertTrue(cached.contains(where: { $0.name == "Oranges" }))
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_saveAndFetchProductDetail() async {
        // Given
        let detail = MockData.sampleProductDetail

        // When
        sut.saveProductDetail(detail)
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let cached):
            XCTAssertEqual(cached.name, "Apples")
            XCTAssertEqual(cached.description, "An apple a day keeps the doctor away.")
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProductDetail_notFound() async {
        // When
        let result = await sut.fetchProductDetail(id: "999")

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ResponseErrorType.noData))
        }
    }

    func test_clearAll() async {
        // Given
        sut.saveProducts(MockData.sampleProducts)

        // When
        sut.clearAll()
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure after clear")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ResponseErrorType.noData))
        }
    }

    func test_upsertProducts() async {
        // Given
        sut.saveProducts([MockData.sampleProduct])

        // When - save again (upsert)
        let updatedProduct = Product(
            productId: "1",
            name: "Green Apples",
            price: 150,
            image: "https://example.com/images/1.jpg"
        )
        sut.saveProducts([updatedProduct])
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let cached):
            XCTAssertEqual(cached.count, 1)
            XCTAssertEqual(cached.first?.name, "Green Apples")
            XCTAssertEqual(cached.first?.price, 150)
        case .failure:
            XCTFail("Expected success")
        }
    }
}
