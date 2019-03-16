import Foundation

public extension DispatchQueue {
    func asyncAfter(intervalSec: Double, execute: @escaping () -> Void) {
        let nanosecs = Int(intervalSec * 1_000_000_000)
        self.asyncAfter(deadline: .now() + .nanoseconds(nanosecs), execute: execute)
    }
    
    func asyncAfter(intervalSec: Int, execute: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + .seconds(intervalSec), execute: execute)
    }
    
    func asyncAfter(intervalMilliSec: Int, execute: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + .milliseconds(intervalMilliSec), execute: execute)
    }
}
