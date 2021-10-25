import Foundation

#warning("Rename me")

public protocol StepBasedTimeCalculating {
    func timeBasedOn(step: Int) -> TimeInterval
}

public protocol LimitedStepBasedTimeCalculating: StepBasedTimeCalculating {
    var maxTimeout: TimeInterval { get }
}
