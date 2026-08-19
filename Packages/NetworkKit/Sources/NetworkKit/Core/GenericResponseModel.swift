//
//  GenericResponseModel.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public struct GenericResponseModel<T: Decodable>: Decodable {

    public let status: Int
    public let code: String?
    public let message: String?
    public let payload: T?

    public init(status: Int, code: String? = nil, message: String? = nil, payload: T? = nil) {
        self.status = status
        self.code = code
        self.message = message
        self.payload = payload
    }
}
