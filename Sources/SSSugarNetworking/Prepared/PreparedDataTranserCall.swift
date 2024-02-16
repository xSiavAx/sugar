import Foundation
import Combine

public protocol PreparedDataTransferCallProxy {
    associatedtype Call: DataTransferResponseRequesting
    
    var service: NetworkService { get }
    var config: NetworkConfig { get }
    var call: Call { get }
}

public extension PreparedDataTransferCallProxy where Call.Response: Decodable {
    @discardableResult
    func perform(completion: @escaping (Result<Call.Response, DataTransferError>) -> Void) -> URLSessionDataTask? {
        call.perform(service: service, config: config, completion: completion)
    }
    
    func publisher() -> AnyPublisher<Call.Response, DataTransferError> {
        call.publisher(service: service, config: config)
    }
    
    func perform() async throws -> Call.Response {
        try await call.perform(service: service, config: config)
    }
    
    func result() async -> Result<Call.Response, DataTransferError> {
        await call.result(service: service, config: config)
    }
}

public extension PreparedDataTransferCallProxy where Call.Response == Void {
    @discardableResult
    func perform(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionDataTask? {
        call.perform(service: service, config: config, completion: completion)
    }
    
    func publisher() -> AnyPublisher<Void, DataTransferError> {
        call.publisher(service: service, config: config)
    }
    
    func perform() async throws {
        try await call.perform(service: service, config: config)
    }
    
    func result() async -> Result<Void, DataTransferError> {
        await call.result(service: service, config: config)
    }
}

public struct PreparedDataTransferCall<Call: DataTransferResponseRequesting>: PreparedDataTransferCallProxy {
    public let service: NetworkService
    public let config: NetworkConfig
    public let call: Call
    
    public init(service: NetworkService, config: NetworkConfig, call: Call) {
        self.service = service
        self.config = config
        self.call = call
    }
}
