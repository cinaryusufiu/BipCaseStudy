//
//  BipConfiguration.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

// MARK: - Configuration

final class BipConfiguration: BipConfigurationProtocol {

    let environment: ConfigurationEnvironment

    private let configDict: [String: Any]

    init() {
        self.environment = ConfigurationEnvironment.current
        self.configDict = Bundle.main.plistDictionary(named: environment.configFileName)
    }
}

// MARK: - API

extension BipConfiguration {

    var baseURL: String {
        configDict.value(for: "baseURL") ?? "https://s3-eu-west-1.amazonaws.com/developer-application-test"
    }
}

// MARK: - Cache

extension BipConfiguration {

    var imageCacheMemoryLimit: Int {
        configDict.value(for: "imageCacheMemoryLimit") ?? (50 * 1024 * 1024)
    }

    var imageCacheItemLimit: Int {
        configDict.value(for: "imageCacheItemLimit") ?? 50
    }
}

// MARK: - Converter

extension BipConfiguration {

    var asNetworkConfig: NetworkConfig? {
        guard let baseURL = URL(string: baseURL) else { return nil }
        return NetworkConfig(baseURL: baseURL)
    }
}

// MARK: - Flags

extension BipConfiguration {

    var isDebug: Bool { environment != .production }
}
