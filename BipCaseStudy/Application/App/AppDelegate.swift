//
//  AppDelegate.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import UIKit
import NetworkKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        registerServices()
        setupWindow()
        return true
    }
}

// MARK: - Services

extension AppDelegate {

    private func registerServices() {
        let configuration = BipConfiguration()
        ServiceLocator.shared.register(configuration as BipConfigurationProtocol)

        guard let networkConfig = configuration.asNetworkConfig else { return }

        let networkClient = NetworkClient()
        networkClient.configure(with: networkConfig)

        ServiceLocator.shared.register(networkClient as NetworkClientProtocol)
        ServiceLocator.shared.register(NetworkMonitor() as NetworkMonitorProtocol)
        ServiceLocator.shared.register(CoreDataStack() as CoreDataStackProtocol)
        ServiceLocator.shared.register(ImageCacheManager() as ImageCacheManagerProtocol)
        ServiceLocator.shared.register(BipAlertManager() as BipAlertManagerProtocol)
    }
}

// MARK: - Window

extension AppDelegate {

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window else { return }
        
        AppRouter.shared.setup(window: window)
    }
}

