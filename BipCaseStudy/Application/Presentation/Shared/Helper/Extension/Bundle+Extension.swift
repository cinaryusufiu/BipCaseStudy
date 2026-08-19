//
//  Bundle+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

extension Bundle {

    func plistDictionary(named name: String) -> [String: Any] {
        guard let path = path(forResource: name, ofType: "plist") else { return [:] }
        return NSDictionary(contentsOfFile: path) as? [String: Any] ?? [:]
    }
}
