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
    public struct Join {
        public enum Operation: String {
            /// intersection
            case inner = "inner"
            /// Union left and intersection
            ///
            /// left, left outer
            case left = "left outer"
            /// Union right and intersection
            ///
            /// right, right outer
            case right = "right outer"
            /// Union
            ///
            /// full, full outer
            case full = "full outer"
        }
        public struct Constraint {
            let left: SSDBColumnProtocol
            let right: SSDBColumnProtocol
            
            func toQuery(leftTable: SSDBTable.Type, rightTable: SSDBTable.Type) -> String {
                return "\(leftTable.colName(left)) == \(rightTable.colName(right))"
            }
        }
        public let operation: Operation
        public let table: SSDBTable.Type
        public let constraints: [Constraint]
        
        public init(operation: Operation, table: SSDBTable.Type, constraints: [Constraint]) {
            self.operation = operation
            self.table = table
            self.constraints = constraints
        }
        
        public init(operation: Operation, table: SSDBTable.Type, left: SSDBColumnProtocol, right: SSDBColumnProtocol) {
            self.init(operation: operation, table: table, constraints: [Constraint(left: left, right: right)])
        }
        
        public func toQuery(on right: SSDBTable.Type) -> String {
            let constraintsStr = constraints.map() { $0.toQuery(leftTable: table, rightTable: right) }.joined(separator: " and ")
            return "\(operation) join \(right.tableName) on \(constraintsStr)"
        }
    }
    public struct OrderByComp {
        public enum Order: String {
            /// 0, 1, 2
            case asc = "asc"
            /// 2, 1, 0
            case desc = "desc"
        }
        public let col: SSDBColumnProtocol
        public let table: SSDBTable.Type?
        public let order: Order
        
        public init(col: SSDBColumnProtocol, table: SSDBTable.Type? = nil, order: Order = .asc) {
            self.col = col
            self.table = table
            self.order = order
        }

        public func toString() -> String {
            return "`\(table.colName(col))` \(order.rawValue)"
        }
    }
    public struct LimitComp {
        let val: Int
        let offset: Int?
    }
    private var kind: Kind
    private var table: SSDBTable.Type
    private var columns = [String]()
    private var conditions = SSDBConditionSet()
    private var orderBys = [OrderByComp]()
    private var limitComp: LimitComp?
    private var groupBys = [String]()
    
    public init(_ kind: Kind, table: SSDBTable.Type) {
        self.kind = kind
        self.table = table
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
        return try add(cols: cols, from: table)
    }
    
    @discardableResult
    public func add(cols: [SSDBColumnProtocol], from table: SSDBTable.Type) throws -> SSDBQueryBuilder {
        try ensureKind(not: .delete)
        switch kind {
        case .update:
            columns += Self.placeHoldersFor(cols: cols)
        default:
            columns += cols.map() { table.colName($0) }
        }
        return self
    }
    
    @discardableResult
    public func add(col: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        return try add(col: col, from: table)
    }
    
    @discardableResult
    public func add(col: SSDBColumnProtocol, from table: SSDBTable.Type) throws -> SSDBQueryBuilder {
        return try add(cols: [col])
    }
    
    @discardableResult
    public func add(customCol: String) throws -> SSDBQueryBuilder {
        try ensureKind(not: .insert, .delete)
        columns += [customCol]
        return self
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
    public func add(colCondition: SSDBColumnProtocol, _ operation: SSDBColumnCondition.Operation = .equal, value: String? = nil) throws -> SSDBQueryBuilder {
        return try add(colCondition: colCondition, from: table, operation, value: value)
    }
    
    @discardableResult
    public func add(colCondition col: SSDBColumnProtocol, from table: SSDBTable.Type, _ operation: SSDBColumnCondition.Operation = .equal, value: String? = nil) throws -> SSDBQueryBuilder {
        try ensureKind(not: .insert)
        conditions.add(SSDBColumnCondition(col, from: table, operation, value: value))
        return self
    }
    
    @discardableResult
    public func conditionOperation(_ operation: SSDBConditionSet.Operation) throws -> SSDBQueryBuilder {
        try ensureKind(not: .insert)
        conditions.operation = operation
        return self
    }
    
    @discardableResult
    public func addOrder(_ order: OrderByComp.Order = .asc, by col: SSDBColumnProtocol, from table: SSDBTable.Type) throws -> SSDBQueryBuilder {
        try ensureKind(.select)
        orderBys.append(OrderByComp(col: col, table: table, order: order))
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
        return try addGroupBy(col: col, table: table)
    }
    
    @discardableResult
    public func addGroupBy(col: SSDBColumnProtocol, table: SSDBTable.Type) throws -> SSDBQueryBuilder {
        try ensureKind(.select)
        groupBys.append(table.colName(col))
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

        return "group by \(groupBys.joined(separator: ", "))";
    }
    
    private func ensureHasColums() throws {
        guard !columns.isEmpty else { throw TError.emptyColums }
    }
    
    private static func placeHoldersFor(cols: [SSDBColumnProtocol]) -> [String] {
        return cols.map { "`\($0.name)` = ?" }
    }
}
