import Foundation

public protocol SSDBTable {
    static var tableName: String { get }
    static var regularColumns: [SSDBRegualColumnProtocol] { get }
    static var refCoulmns: [SSDBColumnRefProtocol] { get }
    static var foreignKeys: [SSDBTableComponent] { get }
    
    static var indexCols: [SSDBRegualColumnProtocol]? {get}
    static var customIndexes: [SSDBTableIndexProtocol]? {get}
    
    static func createQuery() -> String
    static func dropQuery() -> String
}

public protocol SSDBTableWithID: SSDBTable {
    associatedtype IDColumn: SSDBTypedColumnProtocol
    
    static var idColumn: IDColumn { get }
    
    static var idLessColumns: [SSDBRegualColumnProtocol] { get }
}

public extension SSDBTable {
    static var colums: [SSDBColumnProtocol] { regularColumns + refCoulmns }
    static var refCoulmns: [SSDBColumnRefProtocol] { [] }
    static var foreignKeys: [SSDBTableComponent] { [] }
    static var indexCols: [SSDBRegualColumnProtocol]? { nil }
    static var customIndexes: [SSDBTableIndexProtocol]? { nil }
    
    static func createQuery() -> String {
        return baseCreateQuery()
    }
    
    static func dropQuery() -> String {
        return baseDropQuery()
    }
    
    static func baseCreateQuery() -> String {
        let components = colums + foreignKeys
        let colComponents = components.map { $0.toCreate() }.joined(separator: ",\n    ")
        let base = """
        create table `\(tableName)` (
            \(colComponents)
        );
        """
        return ([base] + createIndexesQueries()).joined(separator: "\n")
    }
    
    static func baseDropQuery() -> String {
        let base = "drop table \(tableName)"
        return ([base] + dropIndexesQueries()).joined(separator: "\n")
    }
    
    //Query for inserting row with every table colum (including id)
    static func insertQuery() -> String {
        return insertQuery(cols: colums)
    }
    
    static func insertQuery(cols: [SSDBColumnProtocol]) -> String {
        return try! query(.insert).add(cols: cols).build()
    }

    static func selectAllQuery() -> String {
        return try! selectAllQueryBuilder().build()
    }
    
    static func query(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return SSDBQueryBuilder(kind, table: tableName)
    }
    
    static func selectAllQueryBuilder() -> SSDBQueryBuilder {
        return query(.select).add(cols: colums)
    }
    
    private static func createIndexesQueries() -> [String] {
        return allIndexes().map { $0.toCreateComponent() }
    }
    
    private static func dropIndexesQueries() -> [String] {
        return allIndexes().map { $0.toDropComponent() }
    }
    
    private static func allIndexes() -> [SSDBTableIndexProtocol] {
        let base = indexCols?.map { SSDBTableIndex<Self>(col: $0) } ?? []
        let custom = customIndexes ?? []
        
        return base + custom
    }
}

public extension SSDBTableWithID {
    static var regularColumns: [SSDBRegualColumnProtocol] { [idColumn] + idLessColumns }
    
    static func idRef() -> SSDBColumnRef<Self, Self.IDColumn> {
        return SSDBColumnRef(table: Self.self) { $0.idColumn }
    }
    
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
