//
//  CoreDataStackTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
import CoreData
@testable import BipCaseStudy

final class CoreDataStackTests: XCTestCase {

    private var sut: CoreDataStack!

    override func setUp() {
        super.setUp()
        sut = CoreDataStack(inMemory: true)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewContext_isAvailable() {
        XCTAssertNotNil(sut.viewContext)
    }

    func test_newBackgroundContext_isNotViewContext() {
        let bgContext = sut.newBackgroundContext()
        XCTAssertNotEqual(bgContext, sut.viewContext)
    }

    func test_saveContext_withNoChanges_doesNotCrash() {
        sut.saveContext()
    }

    func test_saveContext_withChanges_saves() {
        // Given
        let context = sut.viewContext
        let entity = CDProduct(context: context)
        entity.productId = "test-1"
        entity.name = "Test"
        entity.price = 100
        entity.imageURL = "https://test.com/img.png"
        entity.cachedAt = Date()

        // When
        sut.saveContext()

        // Then
        let request = CDProduct.fetchRequest()
        let results = try? context.fetch(request)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.name, "Test")
    }
}
