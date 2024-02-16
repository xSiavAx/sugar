import Foundation

public struct NetworkTransportResponse<SubjectData> {
    let data: SubjectData?
    let httpResponse: HTTPURLResponse
}
