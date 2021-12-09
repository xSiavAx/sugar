import Foundation

public protocol SSArgVerifying {
    func verify(_ args: inout [Any?]) -> SSArgVerifyResult
}

public extension SSArgVerifying {
    func consume<T>(_ args: inout [Any?]) -> SSArgVerifyConsumeResult<T> {
        guard let picked = args.first else { return .empty }
        guard let picked = picked as? T else { return .cantCast(val: picked) }
        
        args.remove(at: 0)
        
        return .success(picked)
    }
}

public protocol SSCustomArgVerifying: SSArgVerifying {
    associatedtype T
    
    func dummy() -> T
}
