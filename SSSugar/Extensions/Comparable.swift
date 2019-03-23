import Foundation

extension Comparable {
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
