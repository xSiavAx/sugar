import Foundation

public struct SSDBColumnCondition: SSDBQueryCondition {
    public enum Operation: String {
        case equal = "=="
        case notEqual = "!="
        case greater = ">"
        case greaterOrEqual = ">="
        case lower = "<"
        case lowerOrEqual = "<="
    }
    public let column: SSDBColumnProtocol
    public let operation: Operation
    public let value: String?
    
    public init(_ col: SSDBColumnProtocol, _ op: Operation = .equal, value mValue: String? = nil) {
        column = col
        operation = op
        value = mValue
    }
    
    public func toString() -> String {
        let placeHolder = value ?? "?"
        return "`\(column.name)` \(operation.rawValue) \(placeHolder)"
    }
}


