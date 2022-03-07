import Foundation

public struct AriProgIterator: Sequence, IteratorProtocol {
    public static let defaultStart = 0
    public static let defaultStep = 2
    
    private var current: Int
    private let step: Int
    
    public init(start: Int = defaultStart, step: Int = defaultStep) {
        self.current = start
        self.step = step
    }
    
    public mutating func next() -> Int? {
        defer { current += step }
        return current
    }
    
    public static func limited(from start: Int = defaultStart, limit: Int, step: Int = defaultStep) -> LimitedSequenceIterator<Self> {
        return .init(subSequence: AriProgIterator(start: start, step: step), limit: limit)
    }
    
    public static func l(_ start: Int, _ limit: Int, _ step: Int) -> LimitedSequenceIterator<Self> {
        return limited(from: start, limit: limit, step: step)
    }
    
    public static func counting(from start: Int = defaultStart, times: Int, step: Int = defaultStep) -> CountingIterator<Self> {
        return .init(sequence: AriProgIterator(start: start, step: step), times: times)
    }
    
    public static func c(_ start: Int, _ times: Int, _ step: Int) -> CountingIterator<Self> {
        return counting(from: start, times: times, step: step)
    }
}
