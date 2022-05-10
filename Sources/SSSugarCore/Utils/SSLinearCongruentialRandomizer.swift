import Foundation

/// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
@available(*, deprecated, message: "Works badly. Use GKMersenneTwisterRandomSource from GameplayKit instead.")
public struct SSLinearCongruentialRandomizer {
    public struct Params {
        public let divisor: Double
        public let multiplier: Double
        public let additional: Double
        
        public init(divisor mDivisor: Double, multiplier mMultiplier: Double, additional mAdditional: Double) {
            divisor = mDivisor
            multiplier = mMultiplier
            additional = mAdditional
        }
    }
    /// Default seed value (equals to current TS)
    static public var defaultSeed: Double { Double.random(in: 0..<Double.greatestFiniteMagnitude) }
    /// Algorithm parameter default value
    static public let defaultParams = Params(divisor: 139968.0, multiplier: 3877.0, additional: 29573.0)
    
    /// Current seed
    private var mutatedSeed: Double
    
    /// Algorithm parameters
    public private(set) var params: Params

    public init(withSeed seed : Double = defaultSeed,
         params mParams: Params = defaultParams) {
        mutatedSeed = seed
        params = mParams
    }
}
