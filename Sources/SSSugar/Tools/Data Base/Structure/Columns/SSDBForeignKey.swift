import Foundation

public struct SSDBForeignKey<Table: SSDBTable>: SSDBColumnProtocol {
    public let name: String
    public let optional: Bool
    
    public var unique: Bool { true }
    
    private let refColName: String
    
    public func toCreateComponent() -> String {
        return "foreign key(`\(name)`) references `\(Table.tableName)`(`\(refColName)`)"
    }
    
    public init(optional mOptional: Bool? = nil, col: (Table.Type) -> SSDBColumnProtocol) {
        let column = col(Table.self)
        
        name = "\(Table.tableName)_\(column.name)"
        optional = mOptional ?? column.optional
        refColName = column.name
    }
}
