import Foundation

public class SSChildBasedLimitedTimeCalculator: SSLimitedStepBasedTimeCalculating {
    public let ignoreLevel: Int
    public let baseTimeout: TimeInterval
    public let maxTimeout: TimeInterval
    public let subCalculator: SSStepBasedTimeCalculating
    
    public init(baseTimeout: TimeInterval = 0,
         maxTimeout: TimeInterval = .infinity,
         ignoreLevel: Int = 0,
         subCaculator: SSStepBasedTimeCalculating) {
        self.baseTimeout = baseTimeout
        self.maxTimeout = maxTimeout
        self.ignoreLevel = ignoreLevel
        self.subCalculator = subCaculator
    }
    
    public func timeBasedOn(step: Int) -> TimeInterval {
        if (step < ignoreLevel) { return 0 }
        let time = baseTimeout + subCalculator.timeBasedOn(step: step - ignoreLevel)
        
        if (time >= maxTimeout) {
            return maxTimeout
        }
        return time
    }
}
