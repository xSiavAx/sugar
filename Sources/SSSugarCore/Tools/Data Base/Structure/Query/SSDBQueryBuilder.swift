import Foundation

public enum SSDBQueryError: Error {
    case invalidQueryKind
    case emptyColums
}

public class SSDBQueryBuilder {
    typealias TError = SSDBQueryError
    
    public enum Kind {
        case select
        case insert
        case update
        case delete
    }
    public struct OrderByComp {
        public enum Order: String {
            case asc = "asc"
            case desc = "desc"
        }
        let col: SSDBColumnProtocol
        let order: Order
        
        func toString() -> String {
            return "`\(col.name)` \(order.rawValue)"
        }
    }
    public struct LimitComp {
        let val: Int
        let offset: Int?
    }
    private var kind: Kind
    private var table: String
    private var columns = [String]()
    private var conditions = SSDBConditionSet()
    private var orderBys = [OrderByComp]()
    private var limitComp: LimitComp?
    private var groupBys = [SSDBColumnProtocol]()
    
    public init(_ mKind: Kind, table name: String) {
        kind = mKind
        table = name
    }
    
    public convenience init<Table: SSDBTable>(_ kind: Kind, table: Table.Type) {
        self.init(kind, table: table.tableName)
    }
    
    public func build() throws -> String {
        switch kind {
        case .select: return try select()
        case .insert: return try insert()
        case .update: return try update()
        case .delete: return delete()
        }
    }
    
    @discardableResult
    public func add(cols: [SSDBColumnProtocol]) throws -> SSDBQueryBuilder {
        try ensureKind(not: .delete)
        switch kind {
        case .update:
            columns += Self.placeHoldersFor(cols: cols)
        default:
            columns += cols.map() { $0.name }
        }
        return self
    }
    
    @discardableResult
    public func add(col: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        return try add(cols: [col])
    }
    
    @discardableResult
    public func increment(col: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        try ensureKind(.update)
        columns.append("`\(col.name)` = `\(col.name)` + ?")
        return self
    }
    
    @discardableResult
    public func update(col: SSDBColumnProtocol, build: (String) -> String) throws -> SSDBQueryBuilder {
        try ensureKind(.update)
        columns.append("`\(col.name)` = \(build(col.name))")
        return self
    }
    
    @discardableResult
    public func add(colCondition col: SSDBColumnProtocol, _ operation: SSDBColumnCondition.Operation = .equal, value: String? = nil) throws -> SSDBQueryBuilder {
        try ensureKind(not: .insert)
        conditions.add(SSDBColumnCondition(col, operation, value: value))
        return self
    }
    
    @discardableResult
    public func conditionOperation(_ operation: SSDBConditionSet.Operation) throws -> SSDBQueryBuilder {
        try ensureKind(not: .insert)
        conditions.operation = operation
        return self
    }
    
    @discardableResult
    public func addOrder(_ order: OrderByComp.Order = .asc, by col: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        try ensureKind(.select)
        orderBys.append(OrderByComp(col: col, order: order))
        return self
    }
    
    @discardableResult
    public func setLimit(_ limit: Int, offset: Int? = nil) throws -> SSDBQueryBuilder {
        try ensureKind(.select)
        limitComp = LimitComp(val: limit, offset: offset)
        return self
    }
    
    @discardableResult
    public func addGroupBy(col: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        try ensureKind(.select)
        groupBys.append(col)
        return self
    }
    
    //MARK: - private

    private func ensureKind(_ mKind: Kind) throws {
        guard kind == mKind else { throw TError.invalidQueryKind }
    }
    
    private func ensureKind(not kinds: Kind...) throws {
        guard !kinds.contains(kind) else { throw TError.invalidQueryKind }
    }
    
    private func select() throws -> String {
        try ensureHasColums()
        let columsStr = columns.joined(separator: ", ")

        return "select \(columsStr) from `\(table)`\(selectClausesStr());"
    }
    
    private func insert() throws -> String {
        try ensureHasColums()
        let columsStr = columns.joined(separator: ", ")
        let placeHolders = (0..<columns.count).map {_ in "?" }.joined(separator: ", ")
        
        return "insert into `\(table)` (\(columsStr)) values (\(placeHolders));"
    }
    
    private func update() throws -> String {
        try ensureHasColums()
        let columsStr = columns.joined(separator: ", ")
        
        return "update `\(table)` set \(columsStr)\(updateClausesStr());"
    }
    
    private func delete() -> String {
        return "delete from `\(table)`\(deleteClausesStr());"
    }
    
    private func clausesStr(with components: [String?]) -> String {
        let newComps = components.compactMap() { $0 }
        
        guard !newComps.isEmpty else { return "" }
        return " " + newComps.joined(separator: " ")
    }
    
    private func selectClausesStr() -> String {
        return clausesStr(with: [whereClause(), orderByClause(), limitClause(), groupByClause()])
    }
    
    private func updateClausesStr() -> String {
        return clausesStr(with: [whereClause()])
    }
    
    private func deleteClausesStr() -> String {
        return clausesStr(with: [whereClause()])
    }
    
    private func whereClause() -> String? {
        guard !conditions.isEmpty else { return nil }
        return "where \(conditions.toString())";
    }
    
    private func orderByClause() -> String? {
        guard !orderBys.isEmpty else { return nil }
        let comps = orderBys.map() { $0.toString() }
        
        return "order by \(comps.joined(separator: ", "))";
    }
    
    private func limitClause() -> String? {
        guard let limit = limitComp else { return nil }
        
        var str = "limit \(limit.val)"
        if let offset = limit.offset {
            str += " offset \(offset)"
        }
        return str
    }
    
    private func groupByClause() -> String? {
        guard !groupBys.isEmpty else { return nil }
        let names = groupBys.map() { $0.name }
        
        return "group by \(names.joined(separator: ", "))";
    }
    
    private func ensureHasColums() throws {
        guard !columns.isEmpty else { throw TError.emptyColums }
    }
    
    private static func placeHoldersFor(cols: [SSDBColumnProtocol]) -> [String] {
        return cols.map { "`\($0.name)` = ?" }
    }
}
