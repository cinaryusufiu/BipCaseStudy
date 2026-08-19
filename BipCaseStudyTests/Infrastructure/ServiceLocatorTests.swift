//
//  ServiceLocatorTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import BipCaseStudy

final class ServiceLocatorTests: XCTestCase {

    func test_registerAndResolve() {
        // Given
        let locator = ServiceLocator.shared
        let monitor = NetworkMonitor(isConnected: true)

        // When
        locator.register(monitor as NetworkMonitorProtocol)

        // Then
        let resolved = locator.resolve(NetworkMonitorProtocol.self)
        XCTAssertNotNil(resolved)
        XCTAssertTrue(resolved?.isConnected == true)
    }

    func test_resolve_unregistered_returnsNil() {
        // Given
        let locator = ServiceLocator.shared

        // When
        let resolved = locator.resolve(PriceFormatterStrategy.self)

        // Then
        XCTAssertNil(resolved)
    }

    func test_resolveOrCreate_createsOnFirstCall() {
        // Given
        let locator = ServiceLocator.shared

        // When
        let formatter = locator.resolveOrCreate(DollarPriceFormatter.self) {
            DollarPriceFormatter()
        }

        // Then
        XCTAssertEqual(formatter.format(cents: 100), "$1.00")
    }

    func test_computedProperties_resolveCorrectTypes() {
        // Given
        let locator = ServiceLocator.shared
        let monitor = NetworkMonitor(isConnected: false)
        locator.register(monitor as NetworkMonitorProtocol)

        // When & Then
        XCTAssertNotNil(locator.networkMonitor)
        XCTAssertFalse(locator.networkMonitor?.isConnected ?? true)
    }
}
