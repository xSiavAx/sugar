import Foundation

public struct SSDBConditionSet: SSDBQueryCondition {
    public enum Operation: String {
        case and = "and"
        case or = "or"
    }
    public private(set) var operands = [SSDBQueryCondition]()
    public var operation = Operation.and
    public var isEmpty: Bool { operands.isEmpty }
    
    public mutating func add(_ condition: SSDBQueryCondition) {
        operands.append(condition)
    }
    
    public func toString() -> String {
        return operands.map { $0.toString() }.joined(separator: " \(operation) ");
    }
}
