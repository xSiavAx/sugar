import Foundation

public class SSMockCallArgs {
    public struct IError: Error {
        var description: String
    }
    public var verifies = [SSArgVerifying]()
    
    public func custom<T, Custom: SSCustomArgVerifying>(_ verifier: Custom) -> T where Custom.T == T {
        verifies.append(verifier)
        return verifier.dummy()
    }
    
    public func eq<T: Equatable>(_ val: T) -> T {
        verifies.append(SSEqualArgVerifier(expected: val))
        return val
    }
    
    public func ceq<T>(_ val: T, _ isEqual: @escaping (T, T) -> Bool) -> T {
        verifies.append(SSCustomEqualArgVerifier(expected: val, isEqual: isEqual))
        return val
    }
    
    public func tseq<T: SSTestComparing>(_ val: T) -> T {
        verifies.append(SSTestCompareArgVerifier(expected: val))
        return val
    }
    
    public func same<T: AnyObject>(_ val: T) -> T {
        verifies.append(SSSameArgVerifier(expected: val))
        return val
    }
    
    public func match<T>(_ val: T, onMatch: @escaping (T, Any?) -> Bool) -> T {
        verifies.append(SSMatchArgVerifier(expected: val, match: onMatch))
        return val
    }
    
    public func any<T>(_ val: T) -> T {
        verifies.append(SSAnyArgVerifier<T>())
        return val
    }
    
    public func capture<T>(_ captor: SSBaseValueCaptor<T>) -> T {
        verifies.append(SSCaptorArgVerifier(captor: captor))
        return captor.dummy
    }
    
    public func skip<T>(val: T) -> T {
        verifies.append(SSSkipArgVerifier())
        return val
    }
    
    public func verify(args: [Any?]) -> IError? {
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
