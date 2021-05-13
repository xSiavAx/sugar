import Foundation

public protocol SSDBTable: SSDBStaticComponent {
    static var tableName: String { get }
    static var primaryKey: SSDBPrimaryKeyProtocol? { get }
    static var colums: [SSDBColumnProtocol] { get }
    static var foreignKeys: [SSDBTableComponent] { get }
    
    static var indexes: [SSDBTableIndexProtocol] { get }
    static var triggers: [SSDBComponent] {get}
}


//MARK: - Default implementation

public extension SSDBTable {
    static var primaryKey: SSDBPrimaryKeyProtocol? { nil }
    static var foreignKeys: [SSDBTableComponent] { [] }
    static var indexes: [SSDBTableIndexProtocol] { [] }
    static var triggers: [SSDBComponent] { [] }
    
    static func createQueries(strictExist: Bool) -> [String] {
        return baseCreateQueries(strictExist: strictExist)
    }
    
    static func dropQueries(strictExist: Bool) -> [String] {
        return baseDropQueries(strictExist: strictExist)
    }
    
    static func colName(_ col: SSDBColumnProtocol) -> String {
        return "\(tableName).\(col.name)"
    }
}

extension Optional where Wrapped == SSDBTable.Type {
    func colName(_ col: SSDBColumnProtocol) -> String {
        if let wrapped = self {
            return wrapped.colName(col)
        }
        return col.name
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

//MARK: - Reference Count Update Triggers creating

public extension SSDBTable {
    static func refCountUpdateTriggers<RefCountTable: SSDBRefCountTable, Column: SSDBTypedColumnProtocol>(colReference: (Self.Type) -> SSDBColumnRef<RefCountTable, Column>) -> [SSDBTrigger<Self>] {
        return RefCountTable.updateTriggers(colReference: colReference)
    }
}

//MARK: - Queries

public extension SSDBTable {
    private static var component: String { "table" }
    
    static func baseCreateQueries(strictExist: Bool) -> [String] {
        let colComponents = allComponents().map { $0.toCreate() }
        let table = """
        \(baseCreate(component: component, name: tableName, strictExist: strictExist)) (
            \(colComponents.joined(separator: ",\n    "))
        );
        """
        let indexQueries = createQueriesFor(components: indexes, strictExist: strictExist)
        let triggerQueries = createQueriesFor(components: triggers, strictExist: strictExist)
        return [table] + indexQueries + triggerQueries
    }
    
    static func baseDropQueries(strictExist: Bool) -> [String] {
        let table = "\(baseDrop(component: component, name: tableName, strictExist: strictExist));"
        let indexQueries = dropQueriesFor(components: indexes, strictExist: strictExist)
        let triggerQueries = dropQueriesFor(components: triggers, strictExist: strictExist)
        return triggerQueries + indexQueries + [table]
    }
    
    static func query(_ kind: SSDBQueryBuilder.Kind) -> SSDBQueryBuilder {
        return SSDBQueryBuilder(kind, table: self)
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
    
    static func wherePK(_ kind: SSDBQueryBuilder.Kind) throws -> SSDBQueryBuilder {
        return try wherePK(query(kind))
    }
    
    @discardableResult
    static func wherePK(_ builder: SSDBQueryBuilder) throws -> SSDBQueryBuilder {
        if let primaryKey = primaryKey {
            try primaryKey.cols.forEach() { try builder.add(colCondition: $0) }
        }
        return builder
    }
    
    static func selectAllQueryBuilder() -> SSDBQueryBuilder {
        return try! query(.select).add(cols: colums)
    }
    
    //MARK: - private
    
    private static func allComponents() -> [SSDBTableComponent] {
        var components = colums + foreignKeys
        
        if let pk = primaryKey {
            components.append(pk)
        }
        return components
    }
    
    private static func createQueriesFor(components: [SSDBComponent], strictExist: Bool) -> [String] {
        return components.reduce([], { $0 + $1.createQueries(strictExist: strictExist) })
    }
    
    private static func dropQueriesFor(components: [SSDBComponent], strictExist: Bool) -> [String] {
        return components.reduce([], { $0 + $1.dropQueries(strictExist: strictExist) })
    }
}
