import Foundation
import Combine

public protocol TransportService {
    associatedtype Success
    associatedtype Fail: Error
    associatedtype Task: URLSessionTask
    typealias ResponseResult = Result<Success, Fail>
    
    func request(_ request: URLRequest, completion: @escaping (ResponseResult) -> Void) -> Task
    func publisher(_ request: URLRequest) -> AnyPublisher<Success, Fail>
    func request(_ request: URLRequest) async throws -> Success
    func result(_ request: URLRequest) async -> ResponseResult
}

public extension TransportService {
    func makeProxy<Mapper: NetworkResultMapper>(mapper: Mapper) -> NetworkProxy<Mapper, Self>
    where Mapper.FromFail == Fail, Mapper.FromSuccess == Success {
        return NetworkProxy(mapper: mapper, service: self)
    }
}
