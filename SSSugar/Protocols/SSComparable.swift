import Foundation

public extension SSComparable {
    func compare(_ other: Self) -> ComparisonResult {
        if (self == other) {
            return .orderedSame
        }
        if (self < other) {
            return .orderedAscending
        }
        return .orderedDescending
    }
}
