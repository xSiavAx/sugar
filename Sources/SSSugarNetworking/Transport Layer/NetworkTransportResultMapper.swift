import Foundation

public class NetworkTransportResultMapper<SubjectData>: NetworkResultMapper {
    public typealias FromSuccess = NetworkSessionResponse<SubjectData>
    public typealias FromFail = URLError
    public typealias ToSuccess = NetworkTransportResponse<SubjectData>
    public typealias ToFail = URLError
    
    public init() {}
    
    public func prepare(_ request: URLRequest) {}
    
    public func map(fail: URLError, for request: URLRequest) -> URLError {
        return fail
    }
    
    public func flatMap(
        success: NetworkSessionResponse<SubjectData>, for request: URLRequest
    ) -> Result<NetworkTransportResponse<SubjectData>, URLError> {
        guard let httpResponse = success.response as? HTTPURLResponse else {
            return .failure(.init(.badServerResponse))
        }
        return .success(.init(data: success.data, httpResponse: httpResponse))
    }
}
