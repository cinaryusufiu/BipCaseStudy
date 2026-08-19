//
//  AppRouterProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI
import UIKit

// MARK: - DataReturning

protocol DataReturning {
    associatedtype ReturnType
    var returnDataHandler: CompletionHandler<ReturnType>? { get set }
}

// MARK: - NavigationHandling

@MainActor
protocol NavigationHandling {
    @discardableResult
    func push<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool
    ) -> UIHostingController<AnyView>

    @discardableResult
    func push<V: View & DataReturning, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool,
        onReturn: @escaping CompletionHandler<V.ReturnType>
    ) -> UIHostingController<AnyView>

    func pop(animated: Bool)
    func popToRoot(animated: Bool)
}

// MARK: - PresentationHandling

@MainActor
protocol PresentationHandling {
    @discardableResult
    func present<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool
    ) -> UIHostingController<AnyView>?

    @discardableResult
    func present<V: View & DataReturning, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool,
        onReturn: @escaping CompletionHandler<V.ReturnType>
    ) -> UIHostingController<AnyView>?

    func dismiss(animated: Bool, completion: Completion?)
}

// MARK: - ViewControllerManaging

@MainActor
protocol ViewControllerManaging {
    @discardableResult
    func setRoot<V: View, VM: ObservableObject>(
        _ view: V,
        viewModel: VM,
        animated: Bool
    ) -> UIHostingController<AnyView>
}

// MARK: - AppRouting

@MainActor
protocol AppRouting: NavigationHandling & PresentationHandling & ViewControllerManaging {
    func setup(window: UIWindow)
}
