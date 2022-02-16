import Foundation

public class SSSkipArgVerifier: SSArgVerifying {
    //MARK: - SSArgVerifying
    
    public func verify(_ args: inout [Any?]) -> SSArgVerifyResult {
        return .success
    }
}
