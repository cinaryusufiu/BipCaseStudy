//
//  AppRouter.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI
import UIKit

// MARK: - Implementation

final class AppRouter: AppRouting {

    static let shared = AppRouter()

    private weak var navigationController: UINavigationController?

    private init() {}

    // MARK: - Setup

    func setup(window: UIWindow) {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = .white

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.navigationController = navigationController

        setRoot(SplashPage(), viewModel: SplashViewModel())
    }
}

// MARK: - NavigationHandling

extension AppRouter {

    @discardableResult
    func push<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool = true
    ) -> UIHostingController<AnyView> {
        let hostController = configureHostingController(view: view, viewModel: viewModel)
        navigationController?.pushViewController(hostController, animated: animated)
        return hostController
    }

    @discardableResult
    func push<V: View & DataReturning, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool = true,
        onReturn: @escaping CompletionHandler<V.ReturnType>
    ) -> UIHostingController<AnyView> {
        var mutableView = view
        mutableView.returnDataHandler = onReturn
        return push(mutableView as V, viewModel: viewModel, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
}

// MARK: - ViewControllerManaging

extension AppRouter {

    @discardableResult
    func setRoot<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool = false
    ) -> UIHostingController<AnyView> {
        let hostController = configureHostingController(view: view, viewModel: viewModel)
        navigationController?.setViewControllers([hostController], animated: animated)
        return hostController
    }
}

// MARK: - PresentationHandling

extension AppRouter {

    @discardableResult
    func present<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool = true
    ) -> UIHostingController<AnyView>? {
        let hostController = configureHostingController(view: view, viewModel: viewModel)
        navigationController?.present(hostController, animated: animated)
        return hostController
    }

    @discardableResult
    func present<V: View & DataReturning, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool = true,
        onReturn: @escaping CompletionHandler<V.ReturnType>
    ) -> UIHostingController<AnyView>? {
        var mutableView = view
        mutableView.returnDataHandler = onReturn
        return present(mutableView as V, viewModel: viewModel, animated: animated)
    }

    func dismiss(animated: Bool = true, completion: Completion? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - Private

extension AppRouter {

    private func configureHostingController<V: View, VM: ObservableObject>(
        view: V,
        viewModel: VM
    ) -> UIHostingController<AnyView> {
        let wrappedView = AnyView(view.environmentObject(viewModel))
        let hostController = UIHostingController(rootView: wrappedView)
        hostController.view.backgroundColor = .white
        return hostController
    }
}
