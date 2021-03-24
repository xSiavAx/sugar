import Foundation

public protocol SSDBTable {
    var tableName: String { get }
    var columns: [SSDBColumnProtocol] { get }
    var indexes: [SSDBTableIndexProtocol]? {get}
    
    func createQuery() -> String
    func dropQuery() -> String
}

public protocol SSDBTableWithID: SSDBTable {
    var idColumn: SSDBColumnProtocol { get }
    
    var idLessColumns: [SSDBColumnProtocol] { get }
}

public extension SSDBTable {
    var indexes: [SSDBTableIndexProtocol]? { nil }
    
    func createQuery() -> String {
        return baseCreateQuery()
    }
    
    func dropQuery() -> String {
        return baseDropQuery()
    }
    
    func baseCreateQuery() -> String {
        let tableQuery = try! query(.create).add(cols: columns).build()
        return ([tableQuery] + createIndexesQueries()).joined(separator: "\n")
    }
    
    func baseDropQuery() -> String {
        let tableQuery = try! query(.drop).build()
        return ([tableQuery] + dropIndexesQueries()).joined(separator: "\n")
    }
    
    //Query for inserting row with every table colum (including id)
    func insertQuery() -> String {
        return insertQuery(cols: columns)
    }
    
    func insertQuery(cols: [SSDBColumnProtocol]) -> String {
        return try! query(.insert).add(cols: cols).build()
    }

    func selectAllQuery() -> String {
        return try! selectAllQueryBuilder().build()
    }
    
    func query(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return SSDBQueryBuilder(kind, table: tableName)
    }
    
    func selectAllQueryBuilder() -> SSDBQueryBuilder {
        return query(.select).add(cols: columns)
    }
    
    private func createIndexesQueries() -> [String] {
        guard let indexes = indexes else { return [] }
        return indexes.map { $0.toCreateComponent(table: tableName) }
    }
    
    private func dropIndexesQueries() -> [String] {
        guard let indexes = indexes else { return [] }
        return indexes.map { $0.toDropComponent(table: tableName) }
    }
}

public extension SSDBTableWithID {
    var columns: [SSDBColumnProtocol] { [idColumn] + idLessColumns }
    
    // Query for inserting row with every table colums except id
    func saveQuery() -> String {
        insertQuery(cols: idLessColumns)
    }
    
    func updateQuery(cols: [SSDBColumnProtocol]) -> String {
        return try! whereQuery(.update).add(cols: idLessColumns).build()
    }
    
    func updateQuery() -> String {
        return updateQuery(cols: idLessColumns)
    }
    
    func selectQuery() -> String {
        return try! selectAllQueryBuilder().add(colCondition: idColumn).build()
    }
    
    func removeQuery() -> String {
        return try! whereQuery(.delete).build()
    }
    
    func whereQuery(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return query(kind).add(colCondition: idColumn)
    }
}
