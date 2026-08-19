//
//  BipConfigurationProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

protocol BipConfigurationProtocol {
    var environment: ConfigurationEnvironment { get }
    var baseURL: String { get }
    var imageCacheMemoryLimit: Int { get }
    var imageCacheItemLimit: Int { get }
    var asNetworkConfig: NetworkConfig? { get }
    var isDebug: Bool { get }
}
