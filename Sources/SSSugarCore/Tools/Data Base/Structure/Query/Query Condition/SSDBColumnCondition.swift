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
    public let column: SSDBColumnProtocol
    public let table: SSDBTable.Type?
    public let operation: Operation
    public let value: String?
    
    public init(_ col: SSDBColumnProtocol, from table: SSDBTable.Type? = nil, _ op: Operation = .equal, value mValue: String? = nil) {
        self.column = col
        self.table = table
        self.operation = op
        self.value = mValue
    }
    
    public func toString() -> String {
        let placeHolder = value ?? "?"
        return "`\(table.colName(column))` \(operation.rawValue) \(placeHolder)"
    }
}


