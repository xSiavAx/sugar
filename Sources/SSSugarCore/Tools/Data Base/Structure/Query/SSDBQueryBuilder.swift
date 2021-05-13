import Foundation

public enum SSDBQueryError: Error {
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
    private var columns = [SSDBColumnProtocol]()
    private var updateColumns = [String]()
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
    public func add(cols: [SSDBColumnProtocol]) -> SSDBQueryBuilder {
        columns += cols
        return self
    }
    
    @discardableResult
    public func add(colCondition col: SSDBColumnProtocol, _ operation: SSDBColumnCondition.Operation = .equal, value: String? = nil) -> SSDBQueryBuilder {
        conditions.add(SSDBColumnCondition(col, operation, value: value))
        return self
    }
    
    @discardableResult
    public func update(col: SSDBColumnProtocol) -> SSDBQueryBuilder {
        updateColumns.append("`\(col.name)` = ?")
        return self
    }
    
    @discardableResult
    public func increment(col: SSDBColumnProtocol) -> SSDBQueryBuilder {
        updateColumns.append("`\(col.name)` = `\(col.name)` + ?")
        return self
    }
    
    @discardableResult
    public func update(col: SSDBColumnProtocol, build: (String) -> String) -> SSDBQueryBuilder {
        updateColumns.append("`\(col.name)` = \(build(col.name))")
        return self
    }
    
    @discardableResult
    public func conditionOperation(_ operation: SSDBConditionSet.Operation) -> SSDBQueryBuilder {
        conditions.operation = operation
        return self
    }
    
    @discardableResult
    public func addOrder(_ order: OrderByComp.Order = .asc, by col: SSDBColumnProtocol) -> SSDBQueryBuilder {
        orderBys.append(OrderByComp(col: col, order: order))
        return self
    }
    
    @discardableResult
    public func setLimit(_ limit: Int, offset: Int? = nil) -> SSDBQueryBuilder {
        limitComp = LimitComp(val: limit, offset: offset)
        return self
    }
    
    @discardableResult
    public func addGroupBy(col: SSDBColumnProtocol) -> SSDBQueryBuilder {
        groupBys.append(col)
        return self
    }
    
    //MARK: - private
    
    private func select() throws -> String {
        try ensureHasColums()
        let names = Self.colNamesStrFrom(cols: columns)
        
        return "select \(names) from `\(table)`\(selectClausesStr());"
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
    
    private func insert() throws -> String {
        try ensureHasColums()
        let placeHolders = (0..<columns.count).map {_ in "?" }.joined(separator: ", ")
        let names = Self.colNamesStrFrom(cols: columns)
        
        return "insert into `\(table)` (\(names)) values (\(placeHolders));"
    }
    
    private func update() throws -> String {
        try ensureHasUpdateColums()
        let placeHolders = (Self.placeHoldersFor(cols: columns) + updateColumns).joined(separator: ", ")
        
        return "update `\(table)` set \(placeHolders)\(updateClausesStr());"
    }
    
    private func delete() -> String {
        return "delete from `\(table)`\(deleteClausesStr());"
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
    
    private func ensureHasUpdateColums() throws {
        guard !columns.isEmpty || !updateColumns.isEmpty else { throw TError.emptyColums }
    }
    
    private static func placeHoldersFor(cols: [SSDBColumnProtocol]) -> [String] {
        return cols.map { "`\($0.name)` = ?" }
    }
    
    private static func colNamesStrFrom(cols: [SSDBColumnProtocol]) -> String {
        return cols.map { $0.name }.joined(separator: ", ")
    }
}
