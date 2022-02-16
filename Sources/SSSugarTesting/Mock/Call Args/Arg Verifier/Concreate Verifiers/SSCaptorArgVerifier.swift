import Foundation

public class SSCaptorArgVerifier<T>: SSArgVerifying {
    public let captor: SSBaseValueCaptor<T>
    
    public init(captor: SSBaseValueCaptor<T>) {
        self.captor = captor
    }
    
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        return .fromConsume(result: consume(&args), onValue: onValue(val:))
    }
    
    //MARK: - private
    
    private func onValue(val: T) -> SSArgVerifyResult {
        captor.capture(value: val)
        return .success
    }
}
