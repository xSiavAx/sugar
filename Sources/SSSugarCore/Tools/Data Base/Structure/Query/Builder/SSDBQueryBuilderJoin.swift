import Foundation

public extension SSDBQueryBuilder {
    struct Join {
        public enum Operation: String {
            /// intersection
            case inner = "inner"
            /// Union left and intersection
            ///
            /// left, left outer
            case left = "left outer"
            /// Union right and intersection
            ///
            /// right, right outer
            case right = "right outer"
            /// Union
            ///
            /// full, full outer
            case full = "full outer"
        }
        public struct Constraint {
            let colCondition: ColCondition
            let left: Column
            let right: Column
            
            init(left: Column, right: Column, operation: ColCondition.Operation = .equal) {
                self.colCondition = ColCondition(left, operation, right)
                self.left = left
                self.right = right
            }
            
            func toQuery() -> String {
                return colCondition.toString()
            }
        }
        public let operation: Operation
        public let rTable: SSDBTable.Type
        public let constraints: [Constraint]
        
        public init(operation: Operation = .inner, constraints: [Constraint]) throws {
            guard let _ = SSDBTableComponentHelp.commonTable(constraints.map() { $0.left } ),
                  let rTable = SSDBTableComponentHelp.commonTable(constraints.map() { $0.right }) else {
                    throw TError.invalidJoinColums
            }
            self.operation = operation
            self.rTable = rTable
            self.constraints = constraints
        }
        
        public init(operation: Operation = .inner, col: Column, otherCol: Column) throws {
            try self.init(operation: operation, constraints: [Constraint(left: col, right: otherCol)])
        }
        
        public func toQuery() -> String {
            let constraintsStr = constraints.map() { $0.toQuery() }.joined(separator: " and ")
            return "\(operation) join \(rTable.tableName) on \(constraintsStr)"
        }
    }
}
