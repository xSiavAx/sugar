import Foundation

open class SSMockCallArgs {
    public struct IError: Error {
        var description: String
    }
    open var verifies = [SSArgVerifying]()
    
    open func custom<T, Custom: SSCustomArgVerifying>(_ verifier: Custom) -> T where Custom.T == T {
        verifies.append(verifier)
        return verifier.dummy()
    }
    
    open func eq<T: Equatable>(_ val: T) -> T {
        verifies.append(SSEqualArgVerifier(expected: val))
        return val
    }
    
    open func ceq<T>(_ val: T, _ isEqual: @escaping (T, T) -> Bool) -> T {
        verifies.append(SSCustomEqualArgVerifier(expected: val, isEqual: isEqual))
        return val
    }
    
    open func tseq<T: SSTestComparing>(_ val: T) -> T {
        verifies.append(SSTestCompareArgVerifier(expected: val))
        return val
    }
    
    open func same<T: AnyObject>(_ val: T) -> T {
        verifies.append(SSSameArgVerifier(expected: val))
        return val
    }
    
    open func match<T>(_ val: T, onMatch: @escaping (T, Any?) -> Bool) -> T {
        verifies.append(SSMatchArgVerifier(expected: val, match: onMatch))
        return val
    }
    
    open func any<T>(_ val: T) -> T {
        verifies.append(SSAnyArgVerifier<T>())
        return val
    }
    
    open func capture<T>(_ captor: SSBaseValueCaptor<T>) -> T {
        verifies.append(SSCaptorArgVerifier(captor: captor))
        return captor.dummy
    }
    
    open func skip<T>(val: T) -> T {
        verifies.append(SSSkipArgVerifier())
        return val
    }
    
    open func verify(args: [Any?]) -> IError? {
        var args = args
        
        for argVerifier in verifies {
            switch argVerifier.verify(&args) {
            case .success: break
            case .failure(let message): return .init(description: message)
            }
        }
        guard args.isEmpty else { return .init(description: "Passed args are more then expects. Args that left are\n\(args)") }
        return nil
    }
}
