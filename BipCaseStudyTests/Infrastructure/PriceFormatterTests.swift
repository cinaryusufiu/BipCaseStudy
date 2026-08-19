//
//  PriceFormatterTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import BipCaseStudy

final class PriceFormatterTests: XCTestCase {

    private var sut: DollarPriceFormatter!

    override func setUp() {
        super.setUp()
        sut = DollarPriceFormatter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_format_wholeAmount() {
        XCTAssertEqual(sut.format(cents: 100), "$1.00")
    }

    func test_format_withCents() {
        XCTAssertEqual(sut.format(cents: 120), "$1.20")
        XCTAssertEqual(sut.format(cents: 167), "$1.67")
        XCTAssertEqual(sut.format(cents: 999), "$9.99")
    }

    func test_format_zeroCents() {
        XCTAssertEqual(sut.format(cents: 0), "$0.00")
    }

    func test_format_largeAmount() {
        XCTAssertEqual(sut.format(cents: 100000), "$1000.00")
    }

    func test_format_singleDigitCents() {
        XCTAssertEqual(sut.format(cents: 5), "$0.05")
        XCTAssertEqual(sut.format(cents: 50), "$0.50")
    }
}
