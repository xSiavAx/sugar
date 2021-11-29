import Foundation

public protocol SSTimeoutExecutor: SSExecutor {
    func executeAfter(sec: Double, _ work: @escaping () -> Void)
    func executeAfter(sec: Int, _ work: @escaping () -> Void)
}

extension DispatchQueue: SSTimeoutExecutor {
    public func executeAfter(sec: Double, _ work: @escaping () -> Void) {
        asyncAfter(intervalSec: sec, execute: work)
    }
    
    public func executeAfter(sec: Int, _ work: @escaping () -> Void) {
        asyncAfter(intervalSec: sec, execute: work)
    }
}
