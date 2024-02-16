import Foundation

public protocol PreparedDataTransferCallBuilding {
    func build<Request: DataTransferResponseRequesting>(_ call: Request) -> PreparedDataTransferCall<Request>
}

public final class PreparedDataTransferCallBuilder: PreparedDataTransferCallBuilding {
    public let service: NetworkService
    public let config: NetworkConfig
    
    public init(service: NetworkService, config: NetworkConfig) {
        self.service = service
        self.config = config
    }
    
    public func build<Request: DataTransferResponseRequesting>(_ call: Request) -> PreparedDataTransferCall<Request> {
        return .init(service: service, config: config, call: call)
    }
}
