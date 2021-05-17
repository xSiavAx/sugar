import Foundation

public enum SSDBQueryError: Error {
    case invalidQueryKind
    case emptyColums
    case invalidJoinColums
}

public class SSDBQueryBuilder {
    typealias TError = SSDBQueryError
    public typealias Column = SSDBColumnProtocol
    public typealias TalbeT = SSDBTable.Type
    public typealias Builder = SSDBQueryBuilder
    public typealias ColCondition = SSDBColumnCondition
    
    public enum Kind {
        case select
        case insert
        case update
        case delete
        
        var isSelect: Bool { self == .select }
    }
    private var kind: Kind
    private var table: TalbeT
    private var joins = [Join]()
    private var columns = [ColComp]()
    private var conditions = SSDBConditionSet()
    private var orderBys = [OrderByComp]()
    private var limitComp: LimitComp?
    private var groupBys = [Column]()
    
    public init(_ kind: Kind, table: TalbeT) {
        self.kind = kind
        self.table = table
    }
    
    //MARK: - Build
    
    public func build() throws -> String {
        switch kind {
        case .select: return try select()
        case .insert: return try insert()
        case .update: return try update()
        case .delete: return delete()
        }
    }
    
    @discardableResult
    public func join(_ join: Join) throws -> Builder {
        try ensureKind(.select)
        return self
    }
    
    @discardableResult
    public func join(_ kind: Join.Operation = .inner, left: Column, right: Column) throws -> Builder {
        return try join(.init(operation: kind, col: left, otherCol: right))
    }
    
    @discardableResult
    public func join(_ kind: Join.Operation = .inner, ref: SSDBColumnRefProtocol) throws -> Builder {
        return try join(.init(operation: kind, col: ref, otherCol: ref.reference))
    }

    @discardableResult
    public func add(cols: [Column]) throws -> Builder {
        try ensureKind(not: .delete)
        switch kind {
        case .update:
            columns += cols.map() { .update($0) }
        case .select:
            columns += cols.map() { .select($0) }
        default:
            columns += cols.map() { .regular($0) }
        }
        return self
    }
    
    @discardableResult
    public func add(col: Column) throws -> Builder {
        return try add(cols: [col])
    }
    
    @discardableResult
    public func add(customCol: String) throws -> Builder {
        try ensureKind(not: .insert, .delete)
        columns.append(.custom(customCol))
        return self
    }
    
    @discardableResult
    public func increment(col: Column) throws -> Builder {
        try ensureKind(.update)
        let name = col.nameFor(select: false)
        columns.append(.custom("\(name) = \(name) + ?"))
        return self
    }
    
    @discardableResult
    public func update(col: Column, build: (String) -> String) throws -> Builder {
        try ensureKind(.update)
        let name = col.nameFor(select: false)
        
        columns.append(.custom("\(name) = \(build(name))"))

        return self
    }
    
    @discardableResult
    public func add(colCondition col: Column, _ operation: ColCondition.Operation = .equal, value: String? = nil) throws -> Builder {
        try ensureKind(not: .insert)
        conditions.add(ColCondition(col, operation, value, select: kind.isSelect))
        return self
    }
    
    @discardableResult
    public func conditionOperation(_ operation: SSDBConditionSet.Operation) throws -> Builder {
        try ensureKind(not: .insert)
        conditions.operation = operation
        return self
    }
    
    @discardableResult
    public func addOrder(_ order: OrderByComp.Order = .asc, by col: Column, from table: TalbeT) throws -> Builder {
        try ensureKind(.select)
        orderBys.append(OrderByComp(col: col, table: table, order: order))
        return self
    }
    
    @discardableResult
    public func setLimit(_ limit: Int, offset: Int? = nil) throws -> Builder {
        try ensureKind(.select)
        limitComp = LimitComp(val: limit, offset: offset)
        return self
    }
    
    @discardableResult
    public func addGroupBy(col: Column) throws -> Builder {
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
    
    //MARK: Build
    
    private func select() throws -> String {
        return "select \(try colNamesStr()) from `\(table.tableName)`\(joinClausesStr())\(selectClausesStr());"
    }
    
    private func insert() throws -> String {
        let placeHolders = (0..<columns.count).map {_ in "?" }.joined(separator: ", ")
        
        return "insert into \(table.tableName) (\(try colNamesStr())) values (\(placeHolders));"
    }
    
    private func update() throws -> String {
        return "update `\(table.tableName)` set \(try colNamesStr())\(updateClausesStr());"
    }
    
    private func delete() -> String {
        return "delete from `\(table.tableName)`\(deleteClausesStr());"
    }
    
    private func colNamesStr() throws -> String {
        try ensureHasColums()
        return columns.map { $0.toQueryComp() }.joined(separator: ", ")
    }
    
    private func clausesStr(with components: [String?]) -> String {
        let newComps = components.compactMap() { $0 }
        
        guard !newComps.isEmpty else { return "" }
        return " " + newComps.joined(separator: " ")
    }
    
    private func joinClausesStr() -> String {
        return clausesStr(with: joins.map() { $0.toQuery() } )
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

        return "group by \(groupBys.map { $0.nameFor(select: true) }.joined(separator: ", "))";
    }
    
    private func ensureHasColums() throws {
        guard !columns.isEmpty else { throw TError.emptyColums }
    }
}
