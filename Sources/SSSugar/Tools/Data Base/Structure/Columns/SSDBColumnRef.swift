import Foundation

public struct SSDBColumnRef<Table: SSDBTable, Column: SSDBTypedColumnProtocol>: SSDBColumnRefProtocol {
    typealias ColType = Column.ColType
    
    public let name: String
    public let column: Column
    
    public var refname: String { column.name }
    
    public func toCreate() -> String {
        return "`\(name)` \(ColType.colName)"
    }
    
    public init(table: Table.Type, col: (Table.Type)->Column) {
        column = col(Table.self)
        name = "\(Table.tableName)_\(column.name)"
    }
}
