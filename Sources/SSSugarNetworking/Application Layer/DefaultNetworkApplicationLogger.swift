import Foundation
import SSSugarCore

public protocol NetworkApplicationLogger {
    func log(request: URLRequest)
    func log(response: HTTPURLResponse, data: Any?, for request: URLRequest)
}

public final class DefaultNetworkApplicationLogger: NetworkApplicationLogger {
    let logger: Logger?
    
    public init(logger: Logger = CommandLineLogger()) {
        self.logger = logger
    }

    public func log(request: URLRequest) {
        startLogMessage()
        logRequestInfo(request)
        logHTTPBody(of: request)
    }

    public func log(response: HTTPURLResponse, data: Any?, for request: URLRequest) {
        startLogMessage()
        guard let requestURL = request.url else {
            return
        }
        logger?.log(message: "Response for url: \(requestURL)", verbosity: .debug)
        logger?.log(message: "Response status: \(response.statusCode)", verbosity: .debug)
        if let dataStr = string(from: data) {
            logger?.log(message: "Response data: \(dataStr)", verbosity: .debug)
        }
    }

    private func string(from data: Any?) -> String? {
        guard let data else { return nil }
        return (data as? Data)?.prettyJson ?? "\(data)"
    }

    private func logRequestInfo(_ request: URLRequest) {
        guard let requestURL = request.url,
              let headers = request.allHTTPHeaderFields,
              let method = request.httpMethod else {
            return
        }
        logger?.log(message: "Request for url: \(requestURL)", verbosity: .debug)
        logger?.log(message: "Request method: \(method)", verbosity: .debug)
        logger?.log(message: "Request headers: \(headers)", verbosity: .debug)
    }

    private func logHTTPBody(of request: URLRequest) {
        guard let httpBody = request.httpBody else {
            return
        }
        let body = httpBody.prettyJson ?? httpBody.text ?? "Data with length \(httpBody.count)"
        
        logger?.log(message: "Request body: \(body)", verbosity: .debug)
    }
    
    private func startLogMessage() {
        logger?.log(message: "--- [Network logger] ---", verbosity: .debug)
    }
}

private extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
    
    var text: String? {
        return .init(data: self, encoding: .utf8)
    }
}
