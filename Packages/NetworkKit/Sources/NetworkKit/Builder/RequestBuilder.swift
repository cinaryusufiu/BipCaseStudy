//
//  RequestBuilder.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol RequestBuilderProtocol {
    func buildRequest<T: Decodable>(from endpoint: Endpoint<T>, config: NetworkConfig) throws -> URLRequest
}

// MARK: - Default Implementation

public final class DefaultRequestBuilder: RequestBuilderProtocol {

    public init() {}

    public func buildRequest<T: Decodable>(
        from endpoint: Endpoint<T>,
        config: NetworkConfig
    ) throws -> URLRequest {
        let url = try resolveURL(from: endpoint, config: config)

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = config.timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        guard let parameters = endpoint.parameters, !parameters.isEmpty else { return request }

        switch endpoint.method {
        case .get:
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return request }
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request.url = components.url ?? url

        default:
            request.httpBody = try endpoint.encoding.encode(parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    // MARK: - Private

    private func resolveURL<T: Decodable>(from endpoint: Endpoint<T>, config: NetworkConfig) throws -> URL {
        guard let fullURLString = endpoint.fullURL else {
            return config.baseURL.appendingPathComponent(endpoint.path)
        }
        guard let url = URL(string: fullURLString) else { throw NetworkError(URLErrorType.invalidURL) }
        return url
    }
}
