import Foundation

public enum RandomNumberGeneratorLimitType {
    case bultin
    case remainder
}

extension RandomNumberGenerator {
    @inlinable public mutating func next<T>(upperBound: T, type: RandomNumberGeneratorLimitType) -> T where T : FixedWidthInteger, T : UnsignedInteger {
        switch type {
        case .bultin:
            return next(upperBound: upperBound)
        case .remainder:
            return next() % upperBound
        }
    }
}
