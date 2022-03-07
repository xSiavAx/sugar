import Foundation

public struct CountingIterator<SubIterator: IteratorProtocol>: Sequence, IteratorProtocol {
    public private(set) var subIterator: SubIterator
    public let firesLimit: Int
    private var fires = 0
    
    public init(subIterator: SubIterator, times: Int) {
        self.subIterator = subIterator
        self.firesLimit = times
    }
    
    public init<Seq: Sequence>(sequence: Seq, times: Int) where Seq.Iterator == SubIterator {
        self.subIterator = sequence.makeIterator()
        self.firesLimit = times
    }
    
    public mutating func next() -> SubIterator.Element? {
        guard fires < firesLimit else { return nil }
        fires += 1
        return subIterator.next()
    }
}

