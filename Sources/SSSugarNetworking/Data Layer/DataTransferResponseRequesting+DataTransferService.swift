import Foundation
import Combine

public enum DataTransferError: Error {
    case cantBuildRequest
    case noData
    case decoding(Error)
    case network(NetworkApplicationError)
}

protocol DataTransferResponseMapper {
    associatedtype Response
    
    func decode(data: Data?) -> Result<Response, DataTransferError>
}

extension DataTransferResponseMapper {
    func resultPublisher(data: Data?) -> AnyPublisher<Response, DataTransferError> {
        return decode(data: data).asAnyPublisher()
    }
}

extension DataTransferResponseRequesting {
    typealias TaskPublisher = AnyPublisher<Response, DataTransferError>
    typealias CompletionResult = Result<Response, DataTransferError>
    typealias CompletionHandler = (CompletionResult) -> Void
    
    @discardableResult
    func perform(
        service: NetworkService,
        config: NetworkConfig,
        onDecode: @escaping (Data?) -> Result<Response, DataTransferError>,
        completion: @escaping CompletionHandler
    ) -> URLSessionDataTask? {
        switch makeRequest(config: config) {
        case .success(let request):
            return service.request(request) { result in
                let result = result
                    .mapError(map(error:))
                    .flatMap { onDecode($0) }
                completion(result)
            }
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
    
    func publisher(
        service: NetworkService,
        config: NetworkConfig,
        onDecode: @escaping (Data?) -> Result<Response, DataTransferError>
    ) -> TaskPublisher {
        switch makeRequest(config: config) {
        case .success(let request):
            return service
                .publisher(request)
                .mapError(map(error:))
                .flatMap { onDecode($0).asAnyPublisher() }
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func perform(
        service: NetworkService,
        config: NetworkConfig,
        onDecode: (Data?) -> Result<Response, DataTransferError>
    ) async throws -> Response {
        let request = try makeRequest(config: config).trySuccess()
        let data = try await service.request(request)
        
        return try onDecode(data).trySuccess()
    }
    
    func result(
        service: NetworkService,
        config: NetworkConfig,
        onDecode: (Data?) -> Result<Response, DataTransferError>
    ) async -> CompletionResult {
        return await makeRequest(config: config)
            .asyncFlatMap { await service.result($0).mapError(map(error:)) }
            .flatMap(onDecode)
    }
    
    // MAKR: - Private
    
    private func makeRequest(config: NetworkConfig) -> Result<URLRequest, DataTransferError> {
        if let request = request(with: config) {
            return .success(request)
        }
        return .failure(.cantBuildRequest)
    }
    
    private func map(error: NetworkApplicationError) -> DataTransferError {
        return .network(error)
    }
}

extension DataTransferResponseRequesting where Response: Decodable {
    private func onDecode(data: Data?) -> Result<Response, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noData) }
            return .success(try responseDecoder.decode(data))
        } catch {
            return .failure(.decoding(error))
        }
    }

    @discardableResult
    func perform(
        service: NetworkService,
        config: NetworkConfig,
        completion: @escaping CompletionHandler
    ) -> URLSessionDataTask? {
        perform(service: service, config: config, onDecode: onDecode(data:), completion: completion)
    }
    
    func publisher(service: NetworkService, config: NetworkConfig) -> TaskPublisher {
        publisher(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func perform(service: NetworkService, config: NetworkConfig) async throws -> Response {
        try await perform(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func result(service: NetworkService, config: NetworkConfig) async -> CompletionResult {
        await result(service: service, config: config, onDecode: onDecode(data:))
    }
}

extension DataTransferResponseRequesting where Response == Void {
    private func onDecode(data: Data?) -> Result<Response, DataTransferError> {
        return .success(())
    }
    
    @discardableResult
    func perform(
        service: NetworkService,
        config: NetworkConfig,
        completion: @escaping CompletionHandler
    ) -> URLSessionDataTask? {
        perform(service: service, config: config, onDecode: onDecode(data:), completion: completion)
    }
    
    func publisher(service: NetworkService, config: NetworkConfig) -> TaskPublisher {
        publisher(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func perform(service: NetworkService, config: NetworkConfig) async throws -> Response {
        try await perform(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func result(service: NetworkService, config: NetworkConfig) async -> CompletionResult {
        await result(service: service, config: config, onDecode: onDecode(data:))
    }
}

extension DataTransferResponseRequesting where Response == Data {
    private func onDecode(data: Data?) -> Result<Response, DataTransferError> {
        guard let data = data else { return .failure(.noData) }
        return .success(data)
    }

    @discardableResult
    func perform(
        service: NetworkService,
        config: NetworkConfig,
        completion: @escaping CompletionHandler
    ) -> URLSessionDataTask? {
        perform(service: service, config: config, onDecode: onDecode(data:), completion: completion)
    }
    
    func publisher(service: NetworkService, config: NetworkConfig) -> TaskPublisher {
        publisher(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func perform(service: NetworkService, config: NetworkConfig) async throws -> Response {
        try await perform(service: service, config: config, onDecode: onDecode(data:))
    }
    
    func result(service: NetworkService, config: NetworkConfig) async -> CompletionResult {
        await result(service: service, config: config, onDecode: onDecode(data:))
    }
}
