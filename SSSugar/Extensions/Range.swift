import Foundation

extension Range where Bound == Int {
    func middle() -> Bound {
        return (lowerBound + upperBound) / 2
    }
}
