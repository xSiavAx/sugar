import Foundation

public class SSTestCompareArgVerifier<T: SSTestComparing>: SSArgVerifying {
    public let expected: T
    
    public init(expected: T) {
        self.expected = expected
    }
    
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        return .fromConsume(result: consume(&args), onValue: onValue(val:))
    }
    
    //MARK: - private
    
    private func onValue(val: T) -> SSArgVerifyResult {
        guard expected.testSameAs(other: val) else { return .failure("Expected arg \(expected) is not equal to \(val)") }
        return .success
    }
}
