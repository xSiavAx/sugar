import Foundation

public class SSAnyArgVerifier<T>: SSArgVerifying {
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        return .fromConsume(result: consume(&args), onValue: onValue(val:))
    }
    
    //MARK: - private
    
    private func onValue(val: T) -> SSArgVerifyResult {
        return .success
    }
}
