import Foundation

public struct CountingSequence<SubSequence: Sequence & IteratorProtocol>: Sequence, IteratorProtocol {
    public private(set) var subSequence: SubSequence
    public let firesLimit: Int
    private var fires = 0
    
    public init(subSequence: SubSequence, times: Int) {
        self.subSequence = subSequence
        self.firesLimit = times
    }
    
    public mutating func next() -> SubSequence.Element? {
        guard fires < firesLimit else { return nil }
        return subSequence.next()
    }
}

