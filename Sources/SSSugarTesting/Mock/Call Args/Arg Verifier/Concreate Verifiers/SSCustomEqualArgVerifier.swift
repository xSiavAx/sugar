import Foundation

public class SSCustomEqualArgVerifier<T>: SSArgVerifying {
    public let expected: T
    public let isEqual: (T, T) -> Bool
    
    public init(expected: T, isEqual: @escaping (T, T) -> Bool) {
        self.expected = expected
        self.isEqual = isEqual
    }
    
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        return .fromConsume(result: consume(&args)) {
            return isEqual(expected, $0) ? .success : .failure("Custom equal did fail")
        }
    }
}
