//
//  ImageCacheManagerTests.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import XCTest
@testable import BipCaseStudy

final class ImageCacheManagerTests: XCTestCase {

    private var sut: ImageCacheManager!

    override func setUp() {
        super.setUp()
        sut = ImageCacheManager(forTesting: true)
    }

    override func tearDown() {
        sut.clearMemoryCache()
        sut.clearDiskCache()
        sut = nil
        super.tearDown()
    }

    // MARK: - Invalid URL

    func test_loadImage_emptyURL_returnsNil() async {
        let result = await sut.loadImage(from: "")
        XCTAssertNil(result)
    }

    func test_loadImage_invalidURL_returnsNil() async {
        let result = await sut.loadImage(from: "not a url")
        XCTAssertNil(result)
    }

    // MARK: - Clear

    func test_clearMemoryCache_doesNotCrash() {
        sut.clearMemoryCache()
    }

    func test_clearDiskCache_doesNotCrash() {
        sut.clearDiskCache()
    }

    // MARK: - Cache Key Consistency

    func test_sameURL_returnsSameResult() async {
        let url = "https://nonexistent.test/img.png"

        let result1 = await sut.loadImage(from: url)
        let result2 = await sut.loadImage(from: url)

        XCTAssertNil(result1)
        XCTAssertNil(result2)
    }

    // MARK: - Expiration

    func test_removeExpiredDiskCache_removesOldFiles() {
        // Given - maxAge 1 second
        let shortLivedCache = ImageCacheManager(forTesting: true, maxAge: 1)
        let fileManager = FileManager.default
        let cacheDir = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)

        // Write a fake cache file with old date
        let fakeFile = cacheDir.appendingPathComponent("expired_test_file")
        fileManager.createFile(atPath: fakeFile.path, contents: Data([0x01]))
        let oldDate = Date().addingTimeInterval(-10)
        try? fileManager.setAttributes([.modificationDate: oldDate], ofItemAtPath: fakeFile.path)

        // When
        shortLivedCache.removeExpiredDiskCache()

        // Then
        XCTAssertFalse(fileManager.fileExists(atPath: fakeFile.path))

        shortLivedCache.clearDiskCache()
    }

    func test_removeExpiredDiskCache_keepsRecentFiles() {
        // Given - maxAge 1 hour
        let cache = ImageCacheManager(forTesting: true, maxAge: 3600)
        let fileManager = FileManager.default
        let cacheDir = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)

        // Write a fresh file
        let freshFile = cacheDir.appendingPathComponent("fresh_test_file")
        fileManager.createFile(atPath: freshFile.path, contents: Data([0x01]))

        // When
        cache.removeExpiredDiskCache()

        // Then
        XCTAssertTrue(fileManager.fileExists(atPath: freshFile.path))

        // Cleanup
        try? fileManager.removeItem(at: freshFile)
        cache.clearDiskCache()
    }
}
