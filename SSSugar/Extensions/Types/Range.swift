import Foundation

public extension Range where Bound == Int {
    /// Returns middle for range with `Int` bounds. Calculated property.
    /// - Note: **Examples**:
    /// ```
    /// let mid = (0..<4) //2
    /// let mid = (0..<5) //2
    /// let mid = (2..<8) //5
    /// ```
    /// - Returns: middle
    var middle: Bound { return (lowerBound + upperBound) / 2 }
}
