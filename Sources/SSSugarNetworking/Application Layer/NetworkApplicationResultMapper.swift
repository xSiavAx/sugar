import Foundation

public class NetworkApplicationResultMapper<SubjectData>: NetworkResultMapper {
    public typealias FromSuccess = NetworkTransportResultMapper<SubjectData>.ToSuccess
    public typealias FromFail = NetworkTransportResultMapper<SubjectData>.ToFail
    public typealias ToSuccess = SubjectData?
    public typealias ToFail = NetworkApplicationError
    
    public let logger: NetworkApplicationLogger
    public let acceptableStatusCodes: Set<Int>
    
    public init(
        acceptableStatusCodes: Set<Int> = .init(HTTPURLResponse.successStatusCodes),
        logger: NetworkApplicationLogger = DefaultNetworkApplicationLogger()
    ) {
        self.logger = logger
        self.acceptableStatusCodes = acceptableStatusCodes
    }
    
    public func prepare(_ request: URLRequest) {
        logger.log(request: request)
    }
    
    public func map(fail: NetworkTransportResultMapper.ToFail, for request: URLRequest) -> NetworkApplicationError {
        return .transportFailure(fail)
    }

    public func flatMap(success: FromSuccess, for request: URLRequest) -> Result<SubjectData?, NetworkApplicationError> {
        logger.log(response: success.httpResponse, data: success.data, for: request)
        if let error = statusCodeError(in: success) {
            return .failure(error)
        }
        return .success(success.data)
    }
    
    private func statusCodeError(in response: NetworkTransportResponse<SubjectData>) -> NetworkApplicationError? {
        let statusCode = response.httpResponse.statusCode
        
        if acceptableStatusCodes.contains(statusCode) {
            return nil
        }
        return .http(statusCode: statusCode, data: response.data)
    }
}

public extension HTTPURLResponse {
    static let successStatusCodes = 200...299
}
