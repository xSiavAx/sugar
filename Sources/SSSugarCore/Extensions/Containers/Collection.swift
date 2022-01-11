import Foundation

public extension Collection where Index == Int {
    func evens() -> [Element] {
        StepSequence.l(0, count, 2).map() { even in
            return self[even]
        }
    }
    
    func odds() -> [Element] {
        StepSequence.l(1, count, 2).map() { odd in
            return self[odd]
        }
    }
}

