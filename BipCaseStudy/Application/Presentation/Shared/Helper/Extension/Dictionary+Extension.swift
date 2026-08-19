//
//  Dictionary+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

extension Dictionary where Key == String {

    func value<T>(for key: String) -> T? {
        self[key] as? T
    }
}
