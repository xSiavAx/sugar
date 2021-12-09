import Foundation

public class SSStepBasedLimitedTimeCaculatorBuilder {
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
    
    public func linear(timePerStep: TimeInterval = 0) -> SSChildBasedLimitedTimeCalculator {
        return SSChildBasedLimitedTimeCalculator(baseTimeout: baseTimeout,
                                       maxTimeout: maxTimeout,
                                       ignoreLevel: ignoreLevel,
                                       subCaculator: SSLinearStepBasedTimeCalculator(timePerStep: timePerStep))
    }
    
    public func exponential() -> SSChildBasedLimitedTimeCalculator {
        return SSChildBasedLimitedTimeCalculator(baseTimeout: baseTimeout,
                                       maxTimeout: maxTimeout,
                                       ignoreLevel: ignoreLevel,
                                       subCaculator: SSExponentialStepBasedTimeCalculator())
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
