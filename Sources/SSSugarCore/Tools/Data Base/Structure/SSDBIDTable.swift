import Foundation

public protocol SSDBIDTable: SSDBTable {
    associatedtype IDColumn: SSDBTypedColumnProtocol
    
    static var idColumn: IDColumn { get }
    
    static var idLessColumns: [SSDBColumnProtocol] { get }
}

//MARK: - SSDBTable

public extension SSDBIDTable {
    static var primaryKey: SSDBPrimaryKeyProtocol? { pk(idColumn) }
    
    static var colums: [SSDBColumnProtocol] { [idColumn] + idLessColumns }
}

//MARK: - Reference Creating

public extension SSDBIDTable {
    static func idRef(prefix: String? = nil, optional: Bool? = nil) -> SSDBColumnRef<Self, Self.IDColumn> {
        return SSDBColumnRef(table: Self.self, prefix: prefix, optional: optional) { $0.idColumn }
    }
}

//MARK: - Queries

public extension SSDBIDTable {
    // Query for inserting row with every table colums except id
    static func saveQuery() -> String {
        insertQuery(cols: idLessColumns)
    }
    
    static func updateQuery() -> String {
        return updateQuery(cols: idLessColumns)
    }
}
