import Foundation

public class SSLinearStepBasedTimeCalculator: SSStepBasedTimeCalculating {
    public let timePerStep: TimeInterval
    
    public init(timePerStep: TimeInterval = 1) {
        self.timePerStep = timePerStep
    }
    
    public func timeBasedOn(step: Int) -> TimeInterval { TimeInterval(step) * timePerStep }
}
