import Foundation

/// Iterator for OoptionSet based on Int raw value.
///
/// Some text
///
/// - Warning:
/// May have unexpected performance for large rawValue. Complexity is O(N), where N - rawValue
///
/// - Complexity:
/// O(N), N - rawValue
///
public struct OptionSetIterator<Set: OptionSet>: IteratorProtocol where Set.RawValue == Int, Set.Element == Set {
    let set: Set
    private let rawValue: Int
    private var nextBitMask = 1
    private var finished: Bool { nextBitMask > rawValue || nextBitMask == 0 }

    public init(set: Set) {
        self.set = set
        self.rawValue = set.rawValue
    }
    

    public mutating func next() -> Set.Element? {
        while let element = pickNext() {
            if (set.contains(element)) {
                return element
            }
        }
        return nil
    }
    
    private mutating func pickNext() -> Set.Element? {
        while (!finished) {
            if let element = createNext() {
                return element
            }
        }
        return nil
    }
    
    private mutating func createNext() -> Set.Element? {
        defer { nextBitMask <<= 1 }
        return Set(rawValue: nextBitMask)
    }
}
