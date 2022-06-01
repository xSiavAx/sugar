import Foundation

public struct SSDBColumnCondition: SSDBQueryCondition {
    public enum Operation: String {
        case equal = "=="
        case notEqual = "!="
        case greater = ">"
        case greaterOrEqual = ">="
        case lower = "<"
        case lowerOrEqual = "<="
        /// `is`
        case same = "is"
        /// `is not`
        case notSame = "is not"
    }
    public let left: String
    public let right: String?
    public let operation: Operation
    
    public init(left: String, operation: Operation, right: String?) {
        self.left = left
        self.right = right
        self.operation = operation
    }
    
    public init(_ col: SSDBColumnProtocol, _ op: Operation = .equal, _ value: String? = nil, select: Bool) {
        self.init(left: col.nameFor(select: select), operation: op, right: value)
    }
    
    public init(_ left: SSDBColumnProtocol, _ op: Operation = .equal, _ right: SSDBColumnProtocol) {
        self.init(left: left.nameFor(select: true), operation: op, right: right.nameFor(select: true))
    }
    
    public func toString() -> String {
        let right = right ?? "?"
        return "\(left) \(operation.rawValue) \(right)"
    }
}


