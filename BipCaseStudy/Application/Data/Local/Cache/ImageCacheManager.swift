//
//  ImageCacheManager.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import UIKit
import CryptoKit

// MARK: - Protocol

protocol ImageCacheManagerProtocol {
    func loadImage(from urlString: String) async -> UIImage?
    func clearMemoryCache()
    func clearDiskCache()
    func removeExpiredDiskCache()
}

// MARK: - Implementation

final class ImageCacheManager: ImageCacheManagerProtocol, @unchecked Sendable {

    private let memoryCache = NSCache<NSString, UIImage>()
    private let lock = NSLock()
    private var activeTasks: [String: Task<UIImage?, Never>] = [:]
    private let diskCacheMaxAge: TimeInterval

    private let diskCacheDirectory: URL = {
        let directory = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }()

    init(maxAge: TimeInterval = 7 * 24 * 60 * 60) {
        guard let config = ServiceLocator.shared.configuration else {
            fatalError("BipConfigurationProtocol not registered")
        }
        self.diskCacheMaxAge = maxAge
        memoryCache.countLimit = config.imageCacheItemLimit
        memoryCache.totalCostLimit = config.imageCacheMemoryLimit
        removeExpiredDiskCache()
    }

    init(forTesting: Bool, maxAge: TimeInterval = 60) {
        self.diskCacheMaxAge = maxAge
        memoryCache.countLimit = 10
        memoryCache.totalCostLimit = 5 * 1024 * 1024
    }
}

// MARK: - Load

extension ImageCacheManager {

    func loadImage(from urlString: String) async -> UIImage? {
        let key = cacheKey(for: urlString)

        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        if let diskImage = loadFromDisk(key: key) {
            memoryCache.setObject(diskImage, forKey: key as NSString, cost: estimateCost(diskImage))
            return diskImage
        }

        return await coalescedDownload(urlString: urlString, key: key)
    }
}

// MARK: - Clear

extension ImageCacheManager {

    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }

    func clearDiskCache() {
        try? FileManager.default.removeItem(at: diskCacheDirectory)
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }

    func removeExpiredDiskCache() {
        let fileManager = FileManager.default
        guard let fileURLs = try? fileManager.contentsOfDirectory(
            at: diskCacheDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey]
        ) else { return }

        let now = Date()

        for fileURL in fileURLs {
            guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
                  let modificationDate = attributes[.modificationDate] as? Date else {
                continue
            }
            if now.timeIntervalSince(modificationDate) >= diskCacheMaxAge {
                try? fileManager.removeItem(at: fileURL)
            }
        }
    }
}

// MARK: - Task Coalescing

extension ImageCacheManager {

    private func coalescedDownload(urlString: String, key: String) async -> UIImage? {
        let task = getOrCreateDownloadTask(urlString: urlString, key: key)
        return await task.value
    }

    private func getOrCreateDownloadTask(urlString: String, key: String) -> Task<UIImage?, Never> {
        lock.withLock {
            if let existingTask = activeTasks[key] {
                return existingTask
            }

            let task = Task<UIImage?, Never> { [weak self] in
                defer { self?.removeActiveTask(for: key) }
                return await self?.download(urlString: urlString, key: key)
            }

            activeTasks[key] = task
            return task
        }
    }

    private func removeActiveTask(for key: String) {
        lock.withLock {
            _ = activeTasks.removeValue(forKey: key)
        }
    }

    private func download(urlString: String, key: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              let image = UIImage(data: data) else {
            return nil
        }

        memoryCache.setObject(image, forKey: key as NSString, cost: data.count)
        saveToDisk(data: data, key: key)

        return image
    }
}

// MARK: - Disk Operations

extension ImageCacheManager {

    private func saveToDisk(data: Data, key: String) {
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        try? data.write(to: fileURL)
    }

    private func loadFromDisk(key: String) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(key)

        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return nil
        }

        guard Date().timeIntervalSince(modificationDate) < diskCacheMaxAge else {
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }

        guard let data = try? Data(contentsOf: fileURL) else { return nil }

        touchFile(at: fileURL)

        return UIImage(data: data)
    }

    private func touchFile(at url: URL) {
        try? FileManager.default.setAttributes(
            [.modificationDate: Date()],
            ofItemAtPath: url.path
        )
    }
}

// MARK: - Utility

extension ImageCacheManager {

    private func cacheKey(for urlString: String) -> String {
        let digest = Insecure.SHA1.hash(data: Data(urlString.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func estimateCost(_ image: UIImage) -> Int {
        image.jpegData(compressionQuality: 1)?.count ?? 0
    }
}
