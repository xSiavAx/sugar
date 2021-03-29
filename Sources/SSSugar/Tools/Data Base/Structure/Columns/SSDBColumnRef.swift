import Foundation

public struct SSDBColumnRef<OtherTable: SSDBTable, Column: SSDBTypedColumnProtocol>: SSDBColumnRefProtocol, SSDBTypedTableComponent, ForeignKeyProducer {
    typealias ColType = Column.ColType
    
    public let name: String
    public let column: Column
    public let optional: Bool
    
    public var refname: String { column.name }
    
    public func toCreate() -> String {
        return "`\(name)` \(ColType.colName)\(nullComponent())"
    }
    
    public init(table: OtherTable.Type, optional mOptional: Bool? = nil, col: (OtherTable.Type)->Column) {
        column = col(OtherTable.self)
        name = "\(OtherTable.tableName)_\(column.name)"
        if let mOptional = mOptional {
            optional = mOptional
        } else {
            optional = column.optional
        }
    }
    
    //MARK: - public
    
    public func fk() -> SSDBForeignKey<OtherTable> {
        return SSDBForeignKey(col: self)
    }
    
    //MARK: - ForeignKeyProducer
    
    public func foreignKey() -> SSDBTableComponent {
        return fk()
    }
    
    //MARK: - private
    
    private func nullComponent() -> String {
        optional ? "" : " not null"
    }
}
