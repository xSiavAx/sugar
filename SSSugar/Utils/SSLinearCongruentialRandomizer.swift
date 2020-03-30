import Foundation

/// Linear Congruential Random implementation. Class conforms to `SSLinearCongruentialGenerator`.
/// May be initialized with seed and algorithm params (divisor, multiplier, additional) or with default values.
/// - Note: Using default param values is recomended, otherwise read algorithm description for accurate values picking.
public struct SSLinearCongruentialRandomizer {
    /// Params used within algorithm implementation.
    public struct Params {
        /// Algorith parameter
        public let divisor: Double
        /// Algorith parameter
        public let multiplier: Double
        /// Algorith parameter
        public let additional: Double
        
        public init(divisor mDivisor: Double, multiplier mMultiplier: Double, additional mAdditional: Double) {
            divisor = mDivisor
            multiplier = mMultiplier
            additional = mAdditional
        }
    }
    /// Default seed value (equals to current TS)
    static public var defaultSeed: Double { Double.random(in: 0..<Double(MAXFLOAT)) }
    /// Algorithm parameter default value
    static public let defaultParams = Params(divisor: 139968.0, multiplier: 3877.0, additional: 29573.0)
    
    /// Current seed
    private var mutatedSeed: Double
    
    /// Algorithm parameters
    public private(set) var params: Params
    
    /// Create new randomizer instance.
    /// - Parameters:
    ///   - seed: Starting seed. Default value are based on current timestamp
    ///   - params: Algorithm parameters. Default value provided
    public init(withSeed seed : Double = defaultSeed,
         params mParams: Params = defaultParams) {
        mutatedSeed = seed
        params = mParams
    }
    
    /// Generate random value in range [0, 1)
    static public func random(seed: Double = defaultSeed) -> Double {
        var randomizer = SSLinearCongruentialRandomizer(withSeed: seed)
        return randomizer.nextNormilized()
    }
    
    /// Generate random value in range [0, 1)
    public mutating func nextNormilized() -> Double {
        let seed = params.applying(to: mutatedSeed)
        
        mutatedSeed = seed.seed
        return seed.normilized
    }
}

extension SSLinearCongruentialRandomizer: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        return UInt64(nextNormilized() * Double(UInt64.max))
    }
}

extension SSLinearCongruentialRandomizer.Params {
    func applying(to seed: Double) -> (seed:Double, normilized:Double) {
        let newSeed = ((seed * multiplier + additional).truncatingRemainder(dividingBy:divisor))
        return (newSeed, newSeed / divisor)
    }
}
