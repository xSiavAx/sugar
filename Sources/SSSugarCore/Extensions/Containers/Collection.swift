import Foundation

public extension Collection where Index == Int {
    func evens() -> [Element] {
        AriProgIterator.l(0, count, 2).map() { even in
            return self[even]
        }
    }
    
    func odds() -> [Element] {
        AriProgIterator.l(1, count, 2).map() { odd in
            return self[odd]
        }
    }
}

