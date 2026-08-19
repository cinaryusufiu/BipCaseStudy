//
//  ResponseHandler.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol ResponseHandlerProtocol: Sendable {
    func handle<T: Decodable>(data: Data, response: URLResponse) throws -> T
}

// MARK: - Default Implementation

public final class DefaultResponseHandler: ResponseHandlerProtocol {

    private let logger: NetworkLogger
    private let decoder: JSONDecoder

    public init(
        logger: NetworkLogger = NetworkLogger(),
        decoder: JSONDecoder = CustomSnakeCaseDecoder()
    ) {
        self.logger = logger
        self.decoder = decoder
    }

    public func handle<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(ResponseErrorType.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw mapHTTPError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.logError("Decoding failed: \(error)")
            throw NetworkError(ClientErrorType.decodingError)
        }
    }
}

// MARK: - Private

extension DefaultResponseHandler {

    private func mapHTTPError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401: return NetworkError(ResponseErrorType.unauthorized)
        case 403: return NetworkError(ResponseErrorType.forbidden)
        case 404: return NetworkError(ResponseErrorType.notFound)
        case 500...599: return NetworkError(ServerErrorType(statusCode: statusCode))
        default: return NetworkError(HTTPErrorType(statusCode: statusCode))
        }
    }
}
