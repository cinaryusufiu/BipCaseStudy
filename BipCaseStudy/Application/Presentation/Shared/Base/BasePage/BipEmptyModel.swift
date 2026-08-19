//
//  BipEmptyModel.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

struct BipEmptyModel {
    var icon: String = BipIcons.tray
    var title: String = "empty_title".localized
    var message: String = ""
    var buttonTitle: String?
    var onButtonTap: Completion?
}
