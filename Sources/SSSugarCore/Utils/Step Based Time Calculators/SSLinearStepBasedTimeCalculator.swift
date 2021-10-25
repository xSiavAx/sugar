import Foundation

#warning("Rename me")

public class LinearStepBasedTimeSubCalculator: StepBasedTimeCalculating {
    public let timePerStep: TimeInterval
    
    public init(timePerStep: TimeInterval = 1) {
        self.timePerStep = timePerStep
    }
    
    public func timeBasedOn(step: Int) -> TimeInterval { TimeInterval(step) * timePerStep }
}
