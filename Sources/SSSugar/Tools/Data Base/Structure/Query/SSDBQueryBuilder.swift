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
    private var kind: Kind
    private var table: String
    private var columns = [SSDBColumnProtocol]()
    private var updateColumns = [String]()
    private var conditions = SSDBConditionSet()
    
    public init(_ mKind: Kind, table name: String) {
        kind = mKind
        table = name
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
    public func update(col: SSDBColumnProtocol, build: (String) -> String) -> SSDBQueryBuilder {
        updateColumns.append("`\(col.name)` = \(build(col.name))")
        return self
    }
    
    @discardableResult
    public func conditionOperation(_ operation: SSDBConditionSet.Operation) -> SSDBQueryBuilder {
        conditions.operation = operation
        return self
    }
    
    //MARK: - private
    
    private func select() throws -> String {
        try ensureHasColums()
        let names = Self.colNamesStrFrom(cols: columns)
        
        return "select \(names) from `\(table)`\(whereClause());"
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
        
        return "update `\(table)` set \(placeHolders)\(whereClause());"
    }
    
    private func delete() -> String {
        return "delete from `\(table)`\(whereClause())"
    }
    
    private func whereClause() -> String {
        if (conditions.isEmpty) {
            return "";
        }
        return " where \(conditions.toString())";
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
