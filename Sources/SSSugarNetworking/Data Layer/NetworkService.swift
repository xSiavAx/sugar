import Foundation
import Combine

public protocol NetworkService: Sendable {
    func request(_ request: URLRequest, completion: @escaping (Result<Data?, NetworkApplicationError>) -> Void) -> URLSessionDataTask
    func publisher(_ request: URLRequest) -> AnyPublisher<Data?, NetworkApplicationError>
    func request(_ request: URLRequest) async throws -> Data?
    func result(_ request: URLRequest) async -> Result<Data?, NetworkApplicationError>
}

// TODO: Copy to MVVM+Clean arch

public protocol FileDownloadService: Sendable {
    func request(_ request: URLRequest, completion: @escaping (Result<URL?, NetworkApplicationError>) -> Void) -> URLSessionDownloadTask
    func publisher(_ request: URLRequest) -> AnyPublisher<URL?, NetworkApplicationError>
    func request(_ request: URLRequest) async throws -> URL?
    func result(_ request: URLRequest) async -> Result<URL?, NetworkApplicationError>
}

extension NetworkProxy: NetworkService where Success == Data?, Fail == NetworkApplicationError, Task == URLSessionDataTask {}
extension NetworkProxy: FileDownloadService where Success == URL?, Fail == NetworkApplicationError, Task == URLSessionDownloadTask {}
