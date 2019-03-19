import Foundation

extension Range where Bound == Int {
    func middle() -> Bound {
        return (upperBound - lowerBound) / 2
    }
}
