import Foundation

public protocol SSDBTable {
    static var tableName: String { get }
    static var primaryKey: SSDBPrimaryKeyProtocol? { get }
    static var colums: [SSDBColumnProtocol] {get}
    static var foreignKeys: [SSDBTableComponent] { get }
    
    static var indexes: [SSDBTableIndexProtocol] {get}
    
    static func createQuery() -> String
    static func dropQuery() -> String
}

//MARK: - Default implementation

public extension SSDBTable {
    static var primaryKey: SSDBPrimaryKeyProtocol? { nil }
    static var foreignKeys: [SSDBTableComponent] { [] }
    static var indexes: [SSDBTableIndexProtocol] { [] }
    
    static func createQuery() -> String {
        return baseCreateQuery()
    }
    
    static func dropQuery() -> String {
        return baseDropQuery()
    }
}

//MARK - Primary key creating

public extension SSDBTable {
    static func pk(_ cols: SSDBColumnProtocol...) -> SSDBPrimaryKey {
        return SSDBPrimaryKey(cols: cols)
    }
}

//MARK - Foreign key creating

public extension SSDBTable {
    static func fks(_ producers: ForeignKeyProducer...) -> [SSDBTableComponent] {
        return producers.map { $0.foreignKey() }
    }
}

//MARK - Index creating

public extension SSDBTable {
    typealias SingleColGetter = (Self.Type) -> SSDBColumnProtocol
    typealias MultipleColGetter = (Self.Type) -> [SSDBColumnProtocol]
    
    static func idx(unique: Bool, _ get: MultipleColGetter) -> SSDBTableIndex<Self> {
        return SSDBTableIndex<Self>(isUnique: unique, cols: get)
    }
    
    static func idx(unique: Bool, _ get: SingleColGetter) -> SSDBTableIndex<Self> {
        return idx(unique: unique, { [get($0)] })
    }
    
    static func idxs(unique: Bool, _ getters: SingleColGetter... ) -> [SSDBTableIndex<Self>] {
        return getters.map() { idx(unique:unique, $0) }
    }
    
    static func idxs(unique: Bool, _ getters: MultipleColGetter... ) -> [SSDBTableIndex<Self>] {
        return getters.map() { idx(unique:unique, $0) }
    }
}

//MARK: - Queries

public extension SSDBTable {
    static func baseCreateQuery() -> String {
        let colComponents = allComponents().map { $0.toCreate() }.joined(separator: ",\n    ")
        let base = """
        create table `\(tableName)` (
            \(colComponents)
        );
        """
        return ([base] + createIndexesQueries()).joined(separator: "\n")
    }
    
    static func baseDropQuery() -> String {
        let base = "drop table \(tableName);"
        return ([base] + dropIndexesQueries()).joined(separator: "\n")
    }
    
    static func query(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return SSDBQueryBuilder(kind, table: tableName)
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
    
    static func selectQuery() -> String {
        return try! wherePK(selectAllQueryBuilder()).build()
    }
    
    static func removeQuery() -> String {
        return try! wherePK(.delete).build()
    }
    
    static func updateQuery(cols: [SSDBColumnProtocol]) -> String {
        return try! wherePK(.update).add(cols: cols).build()
    }
    
    static func wherePK(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return wherePK(query(kind))
    }
    
    @discardableResult
    static func wherePK(_ builder: SSDBQueryBuilder) -> SSDBQueryBuilder {
        if let primaryKey = primaryKey {
            primaryKey.cols.forEach() { builder.add(colCondition: $0) }
        }
        return builder
    }
    
    static func selectAllQueryBuilder() -> SSDBQueryBuilder {
        return query(.select).add(cols: colums)
    }
    
    //MARK: - private
    
    private static func allComponents() -> [SSDBTableComponent] {
        var components = colums + foreignKeys
        
        if let pk = primaryKey {
            components.append(pk)
        }
        return components
    }
    
    private static func createIndexesQueries() -> [String] {
        return indexes.map { $0.toCreateComponent() }
    }
    
    private static func dropIndexesQueries() -> [String] {
        return indexes.map { $0.toDropComponent() }
    }
}
