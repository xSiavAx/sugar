import Foundation
import SSSugarCore

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

// MARK: - SSDataBaseGettingStatement

public protocol SSDataBaseGettingStatement {
    func getInt(pos: Int) throws -> Int
    func getInt64(pos: Int) throws -> Int64
    func getDouble(pos: Int) throws -> Double
    func getString(pos: Int) throws -> String
    func getData(pos: Int) throws -> Data
    
    func isNull(pos: Int) throws -> Bool
}

// MARK: - SSDataBaseStatementProtocol

public protocol SSDataBaseStatementProtocol: SSDataBaseBindingStatement, SSDataBaseGettingStatement, SSReleasable {
    func select() throws -> Bool
    func commit() throws
    func clear() throws
    func reset() throws
}

public extension SSDataBaseStatementProtocol {
    func bind<T: SSDBColType>(_ val: T, pos: Int) throws {
        try val.bindTo(stmt: self, pos: pos)
    }

    func get<T: SSDBColType>(pos: Int) throws -> T {
        return try T.from(stmt: self, pos: pos)
    }

    // MARK: Deprecated

    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `bind<T: SSDBColType>(_ val: T, pos: Int)` instead")
    func bind<T: SSDBColType>(val: T, pos: Int) throws {
        try bind(val, pos: pos)
    }
}

// MARK: - SSDataBaseSavePointProtocol

public protocol SSDataBaseSavePointProtocol: SSReleasable {
    /// Revert all changes withing save point.
    /// - Importnat: Doesnt cause releasing. U should call release() on your own, nevermind did `rollBack` called or not.
    func rollBack() throws
}

// MARK: - SSDataBaseStatementCreator

public protocol SSDataBaseStatementCreator: AnyObject {
    func statement(forQuery : String) throws -> SSDataBaseStatementProtocol
}

// MARK: - SSDataBaseProtocol

public protocol SSDataBaseProtocol: SSTransacted, SSDataBaseStatementCreator, SSDataBaseQueryExecutor, SSCacheContainer {
    func stmtProcessor(query: String) throws -> SSDataBaseStatementProcessor
    func savePoint(withTitle: String) throws -> SSDataBaseSavePointProtocol
    func lastInsrtedRowID() -> Int64
    func transacted(queries: [String]) throws

    // MARK: Deprecated

    /// - Warning: **Deprecated**. Use `transacted(queries:)` insted.
    @available(*, deprecated, renamed: "transacted(queries:)")
    func exec(queries: [String]) throws
}

// MARK: - SSFileBasedDataBase

public protocol SSFileBasedDataBase {
    func close()
    func remove() throws

    // MARK: Deprecated

    /// - Warning: **Deprecated**. Use `remove()` instead.
    @available(*, deprecated, renamed: "remove()")
    func removeDB() throws

    /// - Warning: **Deprecated**. Use `close()` instead.
    @available(*, deprecated, renamed: "close()")
    func finish()
}

// MARK: - SSFileBasedDataBaseStaticCreator

public protocol SSFileBasedDataBaseStaticCreator {
    static func dataBasePath(baseDir: SSDataBase.BaseDir, name: String, prefix: String?) -> URL
    static func dataBasePath(baseDir: URL, name: String, prefix: String?) -> URL
    static func dataBasePath(name: String, prefix: String?) -> URL
    static func defaultDBBaseDir() -> SSDataBase.BaseDir
    static func dbWith(url: URL) throws -> SSDataBaseProtocol & SSFileBasedDataBase

    /// - Warning: **Deprecated**. Use `dbWith(url:)` in pair with `dataBasePath(baseDir:name:prefix:)` instead.
    @available(*, deprecated, message: "Use `dbWith(url:)` in pair with `dataBasePath(baseDir:name:prefix:)` instead")
    static func dbWith(baseDir: SSDataBase.BaseDir, name: String, prefix: String?) throws -> SSDataBaseProtocol & SSFileBasedDataBase
    /// - Warning: **Deprecated**. Use `dbWith(url:)` in pair with `dataBasePath(baseDir:name:prefix:)` instead.
    @available(*, deprecated, message: "Use `dbWith(url:)` in pair with `dataBasePath(baseDir:name:prefix:)` instead")
    static func dbWith(baseDir: URL, name: String, prefix: String?) throws -> SSDataBaseProtocol & SSFileBasedDataBase
    /// - Warning: **Deprecated**. Use `dbWith(url:)` in pair with `dataBasePath(name:prefix:)` instead.
    @available(*, deprecated, message: "Use `dbWith(url:)` in pair with `dataBasePath(name:prefix:)` instead")
    static func dbWith(name: String, prefix: String?) throws -> SSDataBaseProtocol & SSFileBasedDataBase
}
