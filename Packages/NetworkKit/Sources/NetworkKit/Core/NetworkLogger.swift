//
//  NetworkLogger.swift
//  NetworkKit
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

public final class NetworkLogger: Sendable {

    public init() {}
}

// MARK: - Log Methods

extension NetworkLogger {

    public func logRequest(_ request: URLRequest, body: Data?) {
        #if DEBUG
        print("\n--- REQUEST [\(timestamp())] ---")
        print("\(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "No URL")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { print("  \($0.key): \($0.value)") }
        }

        if let body { printBody(body) }
        #endif
    }

    public func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) {
        #if DEBUG
        let status = (200...299).contains(response.statusCode) ? "SUCCESS" : "FAILURE"
        print("\n--- RESPONSE [\(timestamp())] \(status) (\(String(format: "%.2f", duration))s) ---")
        print("\(response.statusCode) \(response.url?.absoluteString ?? "No URL")")
        printBody(data, truncateAt: 1000)
        #endif
    }

    public func logError(_ message: String) {
        #if DEBUG
        print("\n--- ERROR [\(timestamp())] ---")
        print(message)
        #endif
    }
}

// MARK: - Private

extension NetworkLogger {

    private func printBody(_ data: Data, truncateAt limit: Int? = nil) {
        guard let bodyString = String(data: data, encoding: .utf8) else { return }

        let output = prettyPrint(data) ?? bodyString
        let result = limit.map { output.count > $0 ? String(output.prefix($0)) + "\n... (truncated)" : output } ?? output
        print("Body: \(result)")
    }

    private func prettyPrint(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else { return nil }
        return prettyString
    }

    nonisolated private func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
