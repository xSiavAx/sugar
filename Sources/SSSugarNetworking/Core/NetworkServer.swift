import Foundation

public struct NetworkServer: Equatable, Sendable {
    public enum Scheme: String, Equatable, Sendable {
        case http
        case https
    }
    
    public let scheme: Scheme
    public let host: String
    public let port: Int?

    public init(scheme: Scheme, host: String, port: Int?) {
        self.scheme = scheme
        self.host = host
        self.port = port
    }
}
