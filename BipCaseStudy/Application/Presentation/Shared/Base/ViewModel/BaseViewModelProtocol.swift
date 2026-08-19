//
//  BaseViewModelProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

@MainActor
protocol BaseViewModelProtocol: ObservableObject {
    var pageState: PageState { get set }
    var emptyModel: BipEmptyModel? { get set }

    func triggerAlert(using provider: BipAlertProviderProtocol)
    func triggerNoContent(model: BipEmptyModel)
    func triggerContentPage()
}
