import Foundation

public extension DispatchQueue {
    static private(set) var bg = DispatchQueue(label: "background_serial")
    static private(set) var serialAtomicVars = DispatchQueue(label: "ss_queue_for_synced_atomic_vars")
    static private(set) var concurrentAtomicVars = DispatchQueue(label: "ss_queue_for_concurrent_atomic_vars")
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in secconds. Can be floatvalue, like 0.2 or 0.004.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalSec: Double, execute: @escaping () -> Void) {
        let nanosecs = Int(intervalSec * 1_000_000_000)
        asyncAfter(deadline: .now() + .nanoseconds(nanosecs), execute: execute)
    }
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in secconds.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalSec: Int, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + .seconds(intervalSec), execute: execute)
    }
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in millisecconds.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalMilliSec: Int, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + .milliseconds(intervalMilliSec), execute: execute)
    }
}

extension DispatchQueue: SSExecutor {
    public func execute(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}
