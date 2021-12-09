import Foundation

public class SSExponentialStepBasedTimeCalculator: SSStepBasedTimeCalculating {
    public func timeBasedOn(step: Int) -> TimeInterval { TimeInterval(1 << step) }
}
