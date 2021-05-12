import Foundation

public struct SSDBColumnRef<OtherTable: SSDBTable, Column: SSDBTypedColumnProtocol>: SSDBColumnRefProtocol, SSDBTypedTableComponent, SSDBTypedColumnProtocol, ForeignKeyProducer {
    public typealias ColType = Column.ColType
    
    public let name: String
    public let column: Column
    public let optional: Bool
    
    public var refname: String { column.name }
    
    public func toCreate() -> String {
        return "`\(name)` \(ColType.colName)\(nullComponent())"
    }

    public init(table: OtherTable.Type, prefix: String? = nil, optional mOptional: Bool? = nil, col: (OtherTable.Type)->Column) {
        func prefixComp() -> String {
            if let prefix = prefix {
                return "\(prefix)_"
            }
            return ""
        }
        column = col(OtherTable.self)
        name = "\(prefixComp())\(OtherTable.tableName)_\(column.name)"
        if let mOptional = mOptional {
            optional = mOptional
        } else {
            optional = ColType.isOptionalCol
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
