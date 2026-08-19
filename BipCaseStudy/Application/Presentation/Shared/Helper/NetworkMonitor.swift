//
//  NetworkMonitor.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import Network

// MARK: - Protocol

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    var isConnectedPublisher: Published<Bool>.Publisher { get }
}

// MARK: - Implementation

final class NetworkMonitor: ObservableObject, NetworkMonitorProtocol {

    @Published private(set) var isConnected: Bool = true
    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.bipcasestudy.networkmonitor")

    // MARK: - Init

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    init(isConnected: Bool) {
        monitor = NWPathMonitor()
        self.isConnected = isConnected
    }

    deinit { monitor.cancel() }
}
