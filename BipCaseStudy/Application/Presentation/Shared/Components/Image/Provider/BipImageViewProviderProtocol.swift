//
//  BipImageViewProviderProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

protocol BipImageViewProviderProtocol {
    var imageURL: String? { get }
    var systemName: String? { get }
    var imageName: String? { get }
    var style: BipImageStyle { get }
}
