import Foundation

/// Requeirements to any simple closure (with void args and same return) executor.
public protocol SSExecutor {
    func execute(_ work: @escaping ()->Void)
}

public protocol SSTimeoutExecutor: SSExecutor {
    func executeAfter(sec: Double, _ work: @escaping () -> Void)
    func executeAfter(sec: Int, _ work: @escaping () -> Void)
}

public protocol SSGCDExecutor: SSTimeoutExecutor {
    func underliedQueue() -> DispatchQueue
}

/// Requeirements to executor that able to execute simple closure on main queue.
/// - Note:
/// Default implementation provided. Any class implementing this protocol may not implement it's methods and use their default implementation.
public protocol SSOnMainExecutor {
    /// Asynchroniously execute passed closure on Main queue.
    /// - Parameter work: Closure to execute
    func onMain(_ work: @escaping ()->Void)
}

extension SSOnMainExecutor {
    public func onMain(_ handler: @escaping ()->Void) {
        DispatchQueue.main.async(execute: handler)
    }
}

