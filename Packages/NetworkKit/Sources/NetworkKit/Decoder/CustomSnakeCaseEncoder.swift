//
//  CustomSnakeCaseEncoder.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public class CustomSnakeCaseEncoder: JSONEncoder, @unchecked Sendable {

    public override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
    }
}
