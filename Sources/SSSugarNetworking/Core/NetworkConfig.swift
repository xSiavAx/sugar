import Foundation

public struct NetworkConfig: Equatable, Sendable {
    public let server: NetworkServer
    public let headers: [String: String]

    public init(server: NetworkServer, headers: [String: String] = .init()) {
        self.server = server
        self.headers = headers
    }
}
