import Foundation
import Combine

public struct NetworkSessionResponse<ResponseData> {
    public let data: ResponseData?
    public let response: URLResponse?
    
    public init(data: ResponseData?, response: URLResponse?) {
        self.data = data
        self.response = response
    }
    
    public init(_ tuple: (data: ResponseData?, response: URLResponse?)) {
        self.data = tuple.data
        self.response = tuple.response
    }
}

public protocol NetworkSessionTaskExecutor: TransportService where Success == NetworkSessionResponse<SubjectData>, Fail == URLError {
    associatedtype SubjectData

    func task(with request: URLRequest, handler: @escaping (SubjectData?, URLResponse?, Error?) -> Void) -> Task
    func taskPublisher(with request: URLRequest) -> AnyPublisher<(data: SubjectData?, response: URLResponse?), Fail>
    func perform(with request: URLRequest) async throws -> (data: SubjectData?, response: URLResponse?)
}

extension NetworkSessionTaskExecutor {
    public func request(_ request: URLRequest, completion: @escaping (Result<Success, Fail>) -> Void) -> Task {
        let task = task(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.make(with: error)))
            } else {
                completion(.success(.init(data: data, response: response)))
            }
        }
        task.resume()

        return task
    }

    public func publisher(_ request: URLRequest) -> AnyPublisher<Success, Fail> {
        return taskPublisher(with: request)
            .map { NetworkSessionResponse(data: $0.data, response: $0.response) }
            .eraseToAnyPublisher()
    }

    public func request(_ request: URLRequest) async throws -> Success {
        do {
            return .init(try await perform(with: request))
        } catch {
            throw URLError.make(with: error)
        }
    }

    public func result(_ request: URLRequest) async -> Result<Success, URLError> {
        do {
            return .success(.init(try await perform(with: request)))
        } catch {
            return .failure(.make(with: error))
        }
    }
}

public final class NetworkSessionManager: NetworkSessionTaskExecutor {
    public typealias SubjectData = Data
    public typealias Task = URLSessionDataTask

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func task(with request: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: handler)
    }

    public func taskPublisher(with request: URLRequest) -> AnyPublisher<(data: Data?, response: URLResponse?), URLError> {
        return session.dataTaskPublisher(for: request)
            .map { $0 as (data: SubjectData?, response: URLResponse?) }
            .eraseToAnyPublisher()
    }

    public func perform(with request: URLRequest) async throws -> (data: Data?, response: URLResponse?) {
        return try await session.data(request: request)
    }
}

public final class NetworkFileDownloader: NetworkSessionTaskExecutor {
    public typealias SubjectData = URL
    public typealias Task = URLSessionDownloadTask

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func task(with request: URLRequest, handler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        return session.downloadTask(with: request, completionHandler: handler)
    }

    public func taskPublisher(with request: URLRequest) -> AnyPublisher<(data: URL?, response: URLResponse?), URLError> {
        return Future { [weak self] promise in
            self?.session.downloadTask(with: request) { url, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((data: url, response: response)))
                }
            }
        }
        .mapError { .make(with: $0) }
        .eraseToAnyPublisher()
    }

    public func perform(with request: URLRequest) async throws -> (data: URL?, response: URLResponse?) {
        return try await session.download(request: request)
    }
}

fileprivate extension URLError {
    static func make(with error: Error) -> URLError {
        return error as? URLError ?? .init(.unknown)
    }
}
