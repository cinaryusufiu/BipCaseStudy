//
//  ProductRepositoryTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import NetworkKit
@testable import BipCaseStudy

final class ProductRepositoryTests: XCTestCase {

    private var sut: ProductRepository!
    private var mockRemoteDataSource: MockProductRemoteDataSource!
    private var mockLocalDataSource: MockProductLocalDataSource!
    private var mockNetworkMonitor: MockNetworkMonitor!

    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockProductRemoteDataSource()
        mockLocalDataSource = MockProductLocalDataSource()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = ProductRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource,
            networkMonitor: mockNetworkMonitor
        )
    }

    override func tearDown() {
        sut = nil
        mockRemoteDataSource = nil
        mockLocalDataSource = nil
        mockNetworkMonitor = nil
        super.tearDown()
    }

    // MARK: - Fetch Products - Online

    func test_fetchProducts_online_success() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockRemoteDataSource.mockProductsResult = .success(MockData.sampleProducts)

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(products.first?.name, "Apples")
            XCTAssertEqual(mockLocalDataSource.saveProductsCallCount, 1)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProducts_online_failure_fallsBackToLocal() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockRemoteDataSource.mockProductsResult = .failure(NetworkError(ServerErrorType(statusCode: 500)))
        mockLocalDataSource.storedProducts = MockData.sampleProducts

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 2)
        case .failure:
            XCTFail("Expected success from local fallback")
        }
    }

    func test_fetchProducts_online_failure_emptyLocal() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockRemoteDataSource.mockProductsResult = .failure(NetworkError(ServerErrorType(statusCode: 500)))
        mockLocalDataSource.storedProducts = []

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

    // MARK: - Fetch Products - Offline

    func test_fetchProducts_offline_fromLocal() async {
        // Given
        mockNetworkMonitor.isConnected = false
        mockLocalDataSource.storedProducts = MockData.sampleProducts

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success(let products):
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(mockRemoteDataSource.fetchProductsCallCount, 0)
        case .failure:
            XCTFail("Expected success from local")
        }
    }

    func test_fetchProducts_offline_emptyLocal() async {
        // Given
        mockNetworkMonitor.isConnected = false
        mockLocalDataSource.storedProducts = []

        // When
        let result = await sut.fetchProducts()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError(ResponseErrorType.noData))
        }
    }

    // MARK: - Fetch Product Detail - Online

    func test_fetchProductDetail_online_notCached_fetchesRemote() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockRemoteDataSource.mockProductDetailResult = .success(MockData.sampleProductDetail)

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Apples")
            XCTAssertEqual(detail.description, "An apple a day keeps the doctor away.")
            XCTAssertEqual(mockRemoteDataSource.fetchProductDetailCallCount, 1)
            XCTAssertEqual(mockLocalDataSource.saveProductDetailCallCount, 1)
        case .failure:
            XCTFail("Expected success")
        }
    }

    func test_fetchProductDetail_online_cached_skipsRemote() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockLocalDataSource.storedDetails["1"] = MockData.sampleProductDetail

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Apples")
            XCTAssertEqual(detail.description, "An apple a day keeps the doctor away.")
            XCTAssertEqual(mockRemoteDataSource.fetchProductDetailCallCount, 0)
        case .failure:
            XCTFail("Expected success from cache")
        }
    }

    func test_fetchProductDetail_online_cachedWithoutDescription_fetchesRemote() async {
        // Given
        mockNetworkMonitor.isConnected = true
        mockLocalDataSource.storedDetails["1"] = MockData.sampleProductDetailWithoutDescription
        mockRemoteDataSource.mockProductDetailResult = .success(MockData.sampleProductDetail)

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.description, "An apple a day keeps the doctor away.")
            XCTAssertEqual(mockRemoteDataSource.fetchProductDetailCallCount, 1)
            XCTAssertEqual(mockLocalDataSource.saveProductDetailCallCount, 1)
        case .failure:
            XCTFail("Expected success from remote")
        }
    }

    // MARK: - Fetch Product Detail - Offline

    func test_fetchProductDetail_offline_fromLocal() async {
        // Given
        mockNetworkMonitor.isConnected = false
        mockLocalDataSource.storedDetails["1"] = MockData.sampleProductDetail

        // When
        let result = await sut.fetchProductDetail(id: "1")

        // Then
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Apples")
        case .failure:
            XCTFail("Expected success from local")
        }
    }

    func test_fetchProductDetail_offline_notFound() async {
        // Given
        mockNetworkMonitor.isConnected = false

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
}
