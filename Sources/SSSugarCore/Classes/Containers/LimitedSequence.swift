import Foundation

public struct LimitedSequence<SubSequence: Sequence & IteratorProtocol>: Sequence, IteratorProtocol where SubSequence.Element: Comparable {
    public private(set) var subSequence: SubSequence
    public let limit: Element
    public private(set) var reached = false
    
    public init(subSequence: SubSequence, limit: Element) {
        self.subSequence = subSequence
        self.limit = limit
    }
    
    public mutating func next() -> SubSequence.Element? {
        guard !reached else { return nil }
        guard let next = subSequence.next() else {
            reached = true
            return nil
        }
        guard next < limit else {
            reached = true
            return nil
        }
        return next
    }
}

