//
//  CustomSnakeCaseDecoder.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public class CustomSnakeCaseDecoder: JSONDecoder, @unchecked Sendable {

    public override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
