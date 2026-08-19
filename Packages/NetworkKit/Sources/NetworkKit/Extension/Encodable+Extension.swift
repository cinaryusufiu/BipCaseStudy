//
//  Encodable+Extension.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public extension Encodable {

    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }

    func toDictionarySnakeCase() -> [String: Any] {
        guard let data = try? CustomSnakeCaseEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }
}
