import Foundation

#warning("Rename me")

public class ExponentialStepBasedSubTimeCalculator: StepBasedTimeCalculating {
    public func timeBasedOn(step: Int) -> TimeInterval { TimeInterval(1 << step) }
}
