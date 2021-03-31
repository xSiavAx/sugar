import Foundation

public enum StatementError: Error {
    case alreadyReleased
    
    case cantCompile(code: Int, msg: String)
    case outOfMemory
    
//    case unexpected(code: Int, msg: String)
    case bindError(code: Int, msg: String)
    case selectError(code: Int, msg: String)
    case commitError(code: Int, msg: String)
    
    /// select() hasn't been called or it returns `false`
    case noData
    
    /// Index passed to get or bind method are aout of range of prepared statement columns
    case indexOutOfRange
}

public protocol SSDataBaseBindingStatement {
    func bind(int: Int, pos: Int) throws
    func bind(int64: Int64, pos: Int) throws
    func bind(double: Double, pos: Int) throws
    func bind(string: String, pos: Int) throws
    func bind(data: Data, pos: Int) throws
    
    func bindNull(pos: Int) throws
}

public protocol SSDataBaseGettingStatement {
    func getInt(pos: Int) throws -> Int
    func getInt64(pos: Int) throws -> Int64
    func getDouble(pos: Int) throws -> Double
    func getString(pos: Int) throws -> String
    func getData(pos: Int) throws -> Data
    
    func isNull(pos: Int) throws -> Bool
}

public protocol SSDataBaseStatementProtocol: SSDataBaseBindingStatement, SSDataBaseGettingStatement, SSReleasable {
    func select() throws -> Bool
    func commit() throws
    func clear() throws
}

public protocol SSDataBaseSavePointProtocol: SSReleasable {
    /// Revert all changes withing save point.
    /// - Importnat: Doesnt cause releasing. U should call release() on your own, nevermind did `rollBack` called or not.
    func rollBack() throws
}

public protocol SSDataBaseStatementCreator: AnyObject {
    func statement(forQuery : String) throws -> SSDataBaseStatementProtocol
}

public protocol SSDataBaseProtocol: SSTransacted, SSDataBaseStatementCreator, SSDataBaseQueryExecutor, SSCacheContainer {
    func savePoint(withTitle: String) throws -> SSDataBaseSavePointProtocol
    func lastInsrtedRowID() -> Int64
}

public extension SSDataBaseStatementProtocol {
    func bind<T: SSDBColType>(val: T, pos: Int) throws {
        try val.bindTo(stmt: self, pos: pos)
    }
    
    func get<T: SSDBColType>(pos: Int) throws -> T {
        return try T.from(stmt: self, pos: pos)
    }
}
