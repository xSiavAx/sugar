import Foundation

public protocol SSDBIDTable: SSDBTable {
    associatedtype IDColumn: SSDBTypedColumnProtocol
    
    static var idColumn: IDColumn { get }
    
    static var idLessColumns: [SSDBRegualColumnProtocol] { get }
}

//MARK: - SSDBTable

public extension SSDBIDTable {
    static var regularColumns: [SSDBRegualColumnProtocol] { [idColumn] + idLessColumns }
}

//MARK: - Reference Creating

public extension SSDBIDTable {
    static func idRef() -> SSDBColumnRef<Self, Self.IDColumn> {
        return SSDBColumnRef(table: Self.self) { $0.idColumn }
    }
}

//MARK: - Queries

public extension SSDBIDTable {
    // Query for inserting row with every table colums except id
    static func saveQuery() -> String {
        insertQuery(cols: idLessColumns)
    }
    
    static func updateQuery(cols: [SSDBRegualColumnProtocol]) -> String {
        return try! whereQuery(.update).add(cols: idLessColumns).build()
    }
    
    static func updateQuery() -> String {
        return updateQuery(cols: idLessColumns)
    }
    
    static func selectQuery() -> String {
        return try! selectAllQueryBuilder().add(colCondition: idColumn).build()
    }
    
    static func removeQuery() -> String {
        return try! whereQuery(.delete).build()
    }
    
    static func whereQuery(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return query(kind).add(colCondition: idColumn)
    }
}
