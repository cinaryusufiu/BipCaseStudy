//
//  NetworkMonitorTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import BipCaseStudy

final class NetworkMonitorTests: XCTestCase {

    func test_init_defaultIsConnected() {
        // Given & When
        let sut = NetworkMonitor(isConnected: true)

        // Then
        XCTAssertTrue(sut.isConnected)
    }

    func test_init_withDisconnectedState() {
        // Given & When
        let sut = NetworkMonitor(isConnected: false)

        // Then
        XCTAssertFalse(sut.isConnected)
    }
}
