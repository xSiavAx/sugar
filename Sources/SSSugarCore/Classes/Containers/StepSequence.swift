import Foundation

public struct StepSequence: Sequence, IteratorProtocol {
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
    
    static func limited(from start: Int = defaultStart, limit: Int, step: Int = defaultStep) -> LimitedSequence<Self> {
        return .init(subSequence: StepSequence(start: start, step: step), limit: limit)
    }
    
    static func l(_ start: Int, _ limit: Int, _ step: Int) -> LimitedSequence<Self> {
        return limited(from: start, limit: limit, step: step)
    }
    
    static func counting(from start: Int = defaultStart, times: Int, step: Int = defaultStep) -> CountingIterator<Self> {
        return .init(sequence: StepSequence(start: start, step: step), times: times)
    }
    
    static func c(_ start: Int, _ times: Int, _ step: Int) -> CountingIterator<Self> {
        return counting(from: start, times: times, step: step)
    }
}
