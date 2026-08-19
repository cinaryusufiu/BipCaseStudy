//
//  BaseViewModel.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import Combine
import NetworkKit

// MARK: - Base Implementation

@MainActor
class BaseViewModel: BaseViewModelProtocol {

    @Published var pageState: PageState = .loading
    @Published var emptyModel: BipEmptyModel?
}

// MARK: - Task Execution

extension BaseViewModel {

    func performTask(
        showLoading: Bool = true,
        _ task: @escaping () async throws -> Void
    ) async {
        if showLoading { pageState = .loading }

        do {
            try await task()
        } catch {
            handleError(error)
        }
    }
}

// MARK: - Result Handling

extension BaseViewModel {

    func handleResult<T>(
        _ result: Result<T, NetworkError>,
        onSuccess: CompletionHandler<T>,
        emptyCheck: Predicate<T>? = nil,
        emptyMessage: String = "empty_no_content".localized,
        hasExistingData: Bool = false,
        onRetry: Completion? = nil
    ) {
        switch result {
        case .success(let data):
            if let isEmpty = emptyCheck, isEmpty(data) {
                triggerNoContent(model: BipEmptyModel(message: emptyMessage))
                return
            }
            onSuccess(data)
            triggerContentPage()

        case .failure(let error):
            guard !hasExistingData else {
                handleError(error)
                return
            }
            triggerNoContent(message: error.userFacingMessage, onRetry: onRetry)
        }
    }
}

// MARK: - Error Handling

extension BaseViewModel {

    func handleError(_ error: Error) {
        let message = (error as? NetworkError)?.userFacingMessage ?? error.localizedDescription
        triggerAlert(using: BipErrorAlertProvider(
            title: "error_title".localized,
            message: message,
            buttons: [
                BipAlertButtonModel(
                    title: "ok".localized,
                    action: {},
                    provider: BipPrimaryButtonProvider()
                )
            ]
        ))
    }
}

// MARK: - Trigger Methods

extension BaseViewModel {

    func triggerAlert(using provider: BipAlertProviderProtocol) {
        ServiceLocator.shared.alertManager?.showAlert(using: provider)
    }

    func triggerNoContent(model: BipEmptyModel) {
        emptyModel = model
        pageState = .noContent
    }

    func triggerNoContent(
        message: String,
        icon: String = BipIcons.warning,
        buttonTitle: String? = "try_again".localized,
        onRetry: Completion? = nil
    ) {
        emptyModel = BipEmptyModel(
            icon: icon,
            title: "error_oops".localized,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onRetry
        )
        pageState = .noContent
    }

    func triggerContentPage() {
        pageState = .content
    }
}
