//
//  BipAlertProviderProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

protocol BipAlertProviderProtocol {
    var type: BipAlertType { get }
    func createAlert() -> BipAlertModel
}
