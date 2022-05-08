import Foundation

/// Requirements for tool that executes passed jobs.
///
/// Usually used to encapsulate some implementation (DispatchQueue for ex), it simplifies unit-tests.
public protocol SSExecutor {
    func execute(_ work: @escaping ()->Void)
}

/// Requirements for tool that executes passed jobs after some timeout.
///
/// Usually used to encapsulate some implementation (DispatchQueue for ex), it simplifies unit-tests.
public protocol SSTimeoutExecutor: SSExecutor {
    /// Executes passed job after some time interval
    /// - Parameters:
    ///   - sec: Time interval length in secconds
    ///   - work: Joib to be executed
    func executeAfter(sec: Double, _ work: @escaping () -> Void)
    
    /// Executes passed job after some time interval
    /// - Parameters:
    ///   - sec: Time interval length in secconds
    ///   - work: Joib to be executed
    func executeAfter(sec: Int, _ work: @escaping () -> Void)
}

/// Requirements for SSTimeoutExecutor that owns underlied gcd queue
public protocol SSGCDExecutor: SSTimeoutExecutor {
    /// Returns underlied GCD queue
    func underliedQueue() -> DispatchQueue
}

/// Requeirements to executor that able to execute job on main queue.
/// - Note:
/// Default implementation provided (via GCD main queue). Any class implementing this protocol may not implement it's methods and use their default implementation.
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
