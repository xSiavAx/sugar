import Foundation

public extension DispatchQueue {
    static private(set) var bg = DispatchQueue(label: "background_serial")
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in secconds. Can be floatvalue, like 0.2 or 0.004.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalSec: Double, execute: @escaping () -> Void) {
        let nanosecs = Int(intervalSec * 1_000_000_000)
        self.asyncAfter(deadline: .now() + .nanoseconds(nanosecs), execute: execute)
    }
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in secconds.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalSec: Int, execute: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + .seconds(intervalSec), execute: execute)
    }
    
    /// Submits a work item to a dispatch queue for asynchronous execution after spicified time interval.
    ///
    /// - Parameters:
    ///   - intervalSec: Interval in millisecconds.
    ///   - execute: Work to execute after specified time interval.
    func asyncAfter(intervalMilliSec: Int, execute: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + .milliseconds(intervalMilliSec), execute: execute)
    }
}
