import Foundation
import Combine

public protocol NetworkResultMapper {
    associatedtype FromSuccess
    associatedtype FromFail: Error
    associatedtype ToSuccess
    associatedtype ToFail: Error
    
    typealias FromResponse = Result<FromSuccess, FromFail>
    typealias ToResponse = Result<ToSuccess, ToFail>
    
    func flatMap(success: FromSuccess, for request: URLRequest) -> Result<ToSuccess, ToFail>
    func map(fail: FromFail, for request: URLRequest) -> ToFail
    
    func prepare(_ request: URLRequest)
}

public extension NetworkResultMapper {
    func map(_ from: FromResponse, for request: URLRequest) -> ToResponse {
        return from
            .mapError { map(fail: $0, for: request) }
            .flatMap { flatMap(success: $0, for: request) }
    }
}

public extension Publisher {
    func flatMap<Mapper: NetworkResultMapper>(_ mapper: Mapper, for request: URLRequest) -> AnyPublisher<Mapper.ToSuccess, Mapper.ToFail>
    where Output == Mapper.FromSuccess, Failure == Mapper.FromFail {
        return mapError { mapper.map(fail: $0, for: request) }
            .flatMap {
                mapper.flatMap(success: $0, for: request).asAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
