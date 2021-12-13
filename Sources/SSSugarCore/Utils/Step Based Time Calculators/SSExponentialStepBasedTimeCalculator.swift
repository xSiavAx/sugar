import Foundation

public class SSExponentialStepBasedTimeCalculator: SSStepBasedTimeCalculating {
    public func timeBasedOn(step: Int) -> TimeInterval { .init(1 << step) }
}
