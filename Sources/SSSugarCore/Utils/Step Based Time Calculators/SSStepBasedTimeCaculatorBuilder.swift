import Foundation

#warning("Rename me")

public class StepBasedTimeCaculatorBuilder {
    public var ignoreLevel: Int
    public var baseTimeout: TimeInterval
    public var maxTimeout: TimeInterval
    
    public init(baseTimeout: TimeInterval = 0,
         maxTimeout: TimeInterval = .infinity,
         ignoreLevel: Int = 0) {
        self.baseTimeout = baseTimeout
        self.maxTimeout = maxTimeout
        self.ignoreLevel = ignoreLevel
    }
    
    public func linear(timePerStep: TimeInterval = 0) -> StepBasedTimeCalculator {
        return StepBasedTimeCalculator(baseTimeout: baseTimeout,
                                       maxTimeout: maxTimeout,
                                       ignoreLevel: ignoreLevel,
                                       subCaculator: LinearStepBasedTimeSubCalculator(timePerStep: timePerStep))
    }
    
    public func exponential() -> StepBasedTimeCalculator {
        return StepBasedTimeCalculator(baseTimeout: baseTimeout,
                                       maxTimeout: maxTimeout,
                                       ignoreLevel: ignoreLevel,
                                       subCaculator: ExponentialStepBasedSubTimeCalculator())
    }
    
    //MARK: - Mutators
    
    public func setIgnoreLevel(_ ignoreLevel: Int) -> Self {
        self.ignoreLevel = ignoreLevel
        return self
    }

    public func setBaseTimeout(_ baseTimeout: TimeInterval) -> Self {
        self.baseTimeout = baseTimeout
        return self
    }

    public func setMaxTimeout(_ maxTimeout: TimeInterval) -> Self {
        self.maxTimeout = maxTimeout
        return self
    }
}
