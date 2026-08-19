//
//  Endpoint.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public struct Endpoint<T: Decodable>: @unchecked Sendable {

    public let path: String
    public let fullURL: String?
    public let method: HTTPMethod
    public var headers: [String: String]?
    public let parameters: [String: Any]?
    public let encoding: ParameterEncoding
    public var context: EndpointContext

    public init(
        path: String = "",
        fullURL: String? = nil,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        context: EndpointContext = .api
    ) {
        self.path = path
        self.fullURL = fullURL
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
        self.context = context
    }
}
