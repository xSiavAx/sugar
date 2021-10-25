import Foundation

#warning("Rename me")

public class StepBasedTimeCalculator: LimitedStepBasedTimeCalculating {
    public let ignoreLevel: Int
    public let baseTimeout: TimeInterval
    public let maxTimeout: TimeInterval
    public let subCalculator: StepBasedTimeCalculating
    
    public init(baseTimeout: TimeInterval = 0,
         maxTimeout: TimeInterval = .infinity,
         ignoreLevel: Int = 0,
         subCaculator: StepBasedTimeCalculating) {
        self.baseTimeout = baseTimeout
        self.maxTimeout = maxTimeout
        self.ignoreLevel = ignoreLevel
        self.subCalculator = subCaculator
    }
    
    public func timeBasedOn(step: Int) -> TimeInterval {
        if (step < ignoreLevel) { return 0 }
        let time = baseTimeout + subCalculator.timeBasedOn(step: step)
        
        if (time >= maxTimeout) {
            return maxTimeout
        }
        return time
    }
}
