import Foundation

public struct SSDBColumnRef<Column: SSDBTypedColumnProtocol>: SSDBColumnRefProtocol, SSDBTypedColumnProtocol {
    public typealias ColType = Column.ColType
    
    public var table: SSDBTable.Type
    public var reference: SSDBColumnProtocol { column }
    public var column: Column
    public let optional: Bool
    
    private let prefix: String?
    private var prefixComp: String {
        if let prefix = prefix {
            return prefix + "_"
        }
        return ""
    }
    
    public func toCreate() -> String {
        return "`\(nameFor(select: false))` \(ColType.colName)\(nullComponent())"
    }

    public init(_ table: SSDBTable.Type, prefix: String? = nil, optional mOptional: Bool? = nil, col: Column) {
        self.table = table
        self.prefix = prefix
        self.column = col
        
        if let mOptional = mOptional {
            optional = mOptional
        } else {
            optional = ColType.isOptionalCol
        }
    }
    
    public func nameFor(select: Bool) -> String {
        let name = prefixComp + "\(column.table.tableName)_\(column.nameFor(select: false))"
        
        if (select) {
            return "\(table.tableName).\(name)"
        }
        return name
    }
    
    //MARK: - public
    
    public func fk() -> SSDBForeignKey {
        return try! SSDBForeignKey(cols: [self])
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
