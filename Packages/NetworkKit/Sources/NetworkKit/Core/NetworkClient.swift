//
//  NetworkClient.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

public protocol NetworkClientProtocol: Sendable {
    func configure(with config: NetworkConfig)
    func execute<T: Decodable>(_ endpoint: Endpoint<T>) async -> Result<T, NetworkError>
}

// MARK: - callAsFunction

extension NetworkClientProtocol {

    public func callAsFunction<T: Decodable>(
        requestModel: Encodable,
        path: String,
        headers: [String: String]? = nil,
        context: EndpointContext = .api
    ) async -> Result<T, NetworkError> {
        let endpoint = Endpoint<GenericResponseModel<T>>(
            path: path,
            method: .post,
            headers: headers,
            parameters: requestModel.toDictionary(),
            encoding: JSONEncoding.default,
            context: context
        )

        let result = await execute(endpoint)

        switch result {
        case .success(let response):
            guard response.status == 0 else {
                let message = response.message ?? "Unknown error"
                return .failure(NetworkError(ResponseErrorType.invalidResponse, message: message))
            }
            guard let payload = response.payload else {
                return .failure(NetworkError(ResponseErrorType.noData))
            }
            return .success(payload)

        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Implementation

public final class NetworkClient: NetworkClientProtocol, @unchecked Sendable {

    private let session: NetworkSessionProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let responseHandler: ResponseHandlerProtocol
    private let interceptors: [RequestInterceptorProtocol]
    private let logger: NetworkLogger
    private var config: NetworkConfig?

    public init(
        session: NetworkSessionProtocol = URLSessionAdapter(),
        requestBuilder: RequestBuilderProtocol = DefaultRequestBuilder(),
        responseHandler: ResponseHandlerProtocol = DefaultResponseHandler(),
        interceptors: [RequestInterceptorProtocol] = [LoggingInterceptor()],
        logger: NetworkLogger = NetworkLogger()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.responseHandler = responseHandler
        self.interceptors = interceptors
        self.logger = logger
    }
}

// MARK: - Configuration

extension NetworkClient {

    public func configure(with config: NetworkConfig) {
        self.config = config
    }
}

// MARK: - Execute

extension NetworkClient {

    public func execute<T: Decodable>(_ endpoint: Endpoint<T>) async -> Result<T, NetworkError> {
        let result: Result<T, NetworkError> = await performRequest(endpoint)
        return await MainActor.run { result }
    }
}

// MARK: - Private

extension NetworkClient {

    private func performRequest<T: Decodable>(_ endpoint: Endpoint<T>) async -> Result<T, NetworkError> {
        guard let config else {
            return .failure(NetworkError(ClientErrorType.configurationError))
        }

        do {
            var request = try requestBuilder.buildRequest(from: endpoint, config: config)

            for interceptor in interceptors {
                request = try await interceptor.intercept(request)
            }

            let startTime = Date()
            let (data, response) = try await session.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                logger.logResponse(httpResponse, data: data, duration: Date().timeIntervalSince(startTime))
            }

            let result: T = try responseHandler.handle(data: data, response: response)
            return .success(result)

        } catch let error as NetworkError {
            return .failure(error)
        } catch let urlError as URLError {
            return .failure(mapURLError(urlError))
        } catch {
            return .failure(NetworkError(ClientErrorType.networkError))
        }
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return NetworkError(URLErrorType.noInternetConnection)
        case .timedOut:
            return NetworkError(URLErrorType.timeout)
        default:
            return NetworkError(ClientErrorType.networkError)
        }
    }
}
