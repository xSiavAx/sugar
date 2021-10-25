import Foundation

public protocol SSStepBasedTimeCalculating {
    func timeBasedOn(step: Int) -> TimeInterval
}

public protocol SSLimitedStepBasedTimeCalculating: SSStepBasedTimeCalculating {
    var maxTimeout: TimeInterval { get }
}
