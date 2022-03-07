import Foundation

public struct CycledIterator<SubSequence: Sequence>: Sequence, IteratorProtocol  {
    public private(set) var subSequence: SubSequence
    public private(set) var subIterator: SubSequence.Iterator

    public init(_ subSequence: SubSequence) {
        self.subSequence = subSequence
        self.subIterator = subSequence.makeIterator()
    }

    public mutating func next() -> SubSequence.Element? {
        if let next = subIterator.next() {
            return next
        }
        subIterator = subSequence.makeIterator()
        if let next = subIterator.next() {
            return next
        }
        return nil //Iterator is empty and recreating wouldn't give any results
    }

    public static func counting(_ subSequence: SubSequence, times: Int) -> CountingIterator<Self> {
        return .init(sequence: CycledIterator(subSequence), times: times)
    }
}
