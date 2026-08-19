//
//  BipAlertModel.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

struct BipAlertModel {
    let type: BipAlertType
    let title: String
    let message: String
    let buttons: [BipAlertButtonModel]
}
