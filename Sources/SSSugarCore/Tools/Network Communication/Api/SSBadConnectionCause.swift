import Foundation

public enum SSBadConnectionCause: Equatable {
    case lowSignal
    case badCertificates
    
    public static func fromApiCall(error: ApiCallError) -> Self? {
        switch error {
        case .noConnection: return .lowSignal
        case .badCertificates: return .badCertificates
        default: return nil
        }
    }
}
