import Foundation

public class SSMatchArgVerifier<T>: SSArgVerifying {
    public let expected: T
    public let onMatch: (T, Any?) -> Bool
    
    public init(expected: T, match: @escaping (T, Any?) -> Bool) {
        self.expected = expected
        self.onMatch = match
    }
    
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        guard let picked = args.first else { return .forEmpty() }
        
        args.remove(at: 0)
        
        if (onMatch(expected, picked)) {
            return .success
        }
        return .failure("Vlaue \(String(describing: picked)) doesn't match on expected \(expected)")
    }
}
