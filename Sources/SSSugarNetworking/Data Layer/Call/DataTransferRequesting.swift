import Foundation

public protocol NetworkRequesting {
    var path: String { get }
    var queries: Encodable? { get }
    var queryEncoder: DataTransferRequestEncoding { get }

    var method: DataTransferCallMethod { get }
    var headers: [String: String] { get }
    var body: Encodable? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var bodyEncoder: DataTransferRequestEncoding { get }

    func url(with config: NetworkConfig) -> URL?
    func request(with config: NetworkConfig) -> URLRequest?
}

extension NetworkRequesting {
    public func url(with config: NetworkConfig) -> URL? {
        var components = URLComponents()
        
        components.scheme = config.server.scheme.rawValue
        components.host = config.server.host
        components.port = config.server.port
        components.path = path
        if let queries = queries {
            components.setQueries(queries, encoder: queryEncoder)
        }
        
        return components.url
    }

    public func request(with config: NetworkConfig) -> URLRequest? {
        guard let url = url(with: config) else { return nil }
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        
        request.httpMethod = method.rawValue.capitalized
        request.setHeaders(config.headers)
        request.setHeaders(headers)
        request.httpBody = body?.toData(using: bodyEncoder)
        
        return request
    }
}

// MARK: - Helpers

private extension URLRequest {
    mutating func setHeaders(_ headers: [String: String]) {
        headers.forEach {
            setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

private extension URLComponents {
    mutating func setQueries(_ queries: Encodable, encoder: DataTransferRequestEncoding) {
        if let queriesDict = queries.toDictionary(using: encoder) {
            queryItems = queriesDict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
    }
}

private extension Encodable {
    func toDictionary(using encoder: DataTransferRequestEncoding) -> [String: Any]? {
        let json = try? JSONSerialization.jsonObject(with: encoder.encode(self))
        return json as? [String: Any]
    }
}

private extension Encodable {
    func toData(using encoder: DataTransferRequestEncoding) -> Data? {
        return try? encoder.encode(self)
    }
}
