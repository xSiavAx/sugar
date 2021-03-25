import Foundation

public struct SSDBColumnRef<OtherTable: SSDBTable, Column: SSDBTypedColumnProtocol>: SSDBColumnRefProtocol, SSDBTypedTableComponent {
    typealias ColType = Column.ColType
    
    public let name: String
    public let column: Column
    
    public var refname: String { column.name }
    
    public func toCreate() -> String {
        return "`\(name)` \(ColType.colName)"
    }
    
    public init(table: OtherTable.Type, col: (OtherTable.Type)->Column) {
        column = col(OtherTable.self)
        name = "\(OtherTable.tableName)_\(column.name)"
    }
    
    public func fk() -> SSDBForeignKey<OtherTable> {
        return SSDBForeignKey(col: self)
    }
}
