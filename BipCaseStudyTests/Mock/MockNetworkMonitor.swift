//
//  MockNetworkMonitor.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
@testable import BipCaseStudy

final class MockNetworkMonitor: NetworkMonitorProtocol {

    var isConnected: Bool = true

    var isConnectedPublisher: Published<Bool>.Publisher {
        $_isConnected
    }

    @Published private var _isConnected: Bool = true
}
