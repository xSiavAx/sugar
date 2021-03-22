import Foundation
import SQLite3

/// SQLITE3 statemnet wrapper
///
/// Bind and get starts from zero.
///
/// # Links
/// Error's code [list](https://www.sqlite.org/rescode.html)
///
public class SSDataBaseStatement {
    static let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    static let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private (set) var stmt: OpaquePointer?
    private (set) var selectColumsCount: Int!
    private (set) var hasData: Bool = false
    var db: OpaquePointer
    var isReleased: Bool { stmt == nil }
    
    public init(query: String, db dataBase: OpaquePointer) throws {
        let result = sqlite3_prepare_v2(dataBase, query, -1, &stmt, nil)
        
        guard result == SQLITE_OK, stmt != nil else {
            throw StatementError.cantCompile(code: Int(result), msg: Self.errorMessage(db: dataBase))
        }
        db = dataBase
    }
    
    public func lastOccuredError() -> (code: Int, message: String) {
        return (Self.errorCode(db: db), Self.errorMessage(db: db))
    }
    
    private static func errorCode(db: OpaquePointer) -> Int {
        return Int(sqlite3_errcode(db))
    }
    
    private static func errorMessage(db: OpaquePointer) -> String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    private func ensureNotReleased() throws {
        guard !isReleased else {
            throw StatementError.alreadyReleased
        }
    }
    
    private func selectError(code: Int32) -> StatementError {
        return .selectError(code: Int(code), msg: lastOccuredError().message)
    }
    
    private func commitError(code: Int32) -> StatementError {
        return .commitError(code: Int(code), msg: lastOccuredError().message)
    }
}

extension SSDataBaseStatement: SSDataBaseStatementProtocol {
    public func select() throws -> Bool {
        try ensureNotReleased()
        
        func onRow() {
            if (selectColumsCount == nil) {
                selectColumsCount = Int(sqlite3_column_count(stmt))
            }
            hasData = true
        }
        
        switch sqlite3_step(stmt) {
        case SQLITE_ROW: onRow()
        case SQLITE_DONE: hasData = false
        case let code: throw selectError(code: code)
        }
        return hasData
    }
    
    public func commit() throws {
        try ensureNotReleased()
        
        switch sqlite3_step(stmt) {
        case SQLITE_DONE: sqlite3_reset(stmt)
        case SQLITE_FULL: throw StatementError.outOfMemory
        case let code: throw commitError(code: code)
        }
    }
    
    public func clear() throws {
        try ensureNotReleased()
        sqlite3_clear_bindings(stmt)
    }
}

//MARK: - SSReleasable

extension SSDataBaseStatement {
    public func release() {
        if (!isReleased) {
            sqlite3_finalize(stmt)
            hasData = false
            stmt = nil
        }
    }
}

//MARK: - SSDataBaseBindingStatement

extension SSDataBaseStatement {
    public func bind(int: Int, pos: Int) throws {
        try process() { sqlite3_bind_int(stmt, Int32(pos+1), Int32(int)) }
    }

    public func bind(int64: Int64, pos: Int) throws {
        try process() { sqlite3_bind_int64(stmt, Int32(pos+1), int64) }
    }

    public func bind(double: Double, pos: Int) throws {
        try process() { sqlite3_bind_double(stmt, Int32(pos+1), double) }
    }
    
    public func bind(string: String, pos: Int) throws {
        try process() {
            sqlite3_bind_text(stmt, Int32(pos+1), string, -1, SSDataBaseStatement.SQLITE_TRANSIENT)
        }
    }
    
    public func bind(data: Data, pos: Int) throws {
        try process() {
            func onData(_ ptr: UnsafeRawBufferPointer) -> Int32 {
                sqlite3_bind_blob(stmt, Int32(pos+1), ptr.baseAddress, Int32(data.count), SSDataBaseStatement.SQLITE_TRANSIENT)
            }
            return data.withUnsafeBytes(onData(_:))
        }
    }
    
    public func bindNull(pos: Int) throws {
        try process() { sqlite3_bind_null(stmt, Int32(pos+1)) }
    }
    
    //MARK: private
    
    private func process(bind: () -> Int32 ) throws {
        try ensureNotReleased()

        switch bind() {
        case SQLITE_OK: break;
        case SQLITE_RANGE: throw StatementError.indexOutOfRange
        case let code: throw bindError(code: code)
        }
    }
    
    private func bindError(code: Int32) -> StatementError {
        return .commitError(code: Int(code), msg: lastOccuredError().message)
    }
}

//MARK: - SSDataBaseGettingStatement

extension SSDataBaseStatement {
    public func getInt(pos: Int) throws -> Int {
        return try get(pos: pos) { (pos) in
            return Int(sqlite3_column_int(stmt, Int32(pos)))
        }
    }
    
    public func getInt64(pos: Int) throws -> Int64 {
        return try get(pos: pos) { (pos) in
            return Int64(sqlite3_column_int64(stmt, Int32(pos)))
        }
    }
    
    public func getDouble(pos: Int) throws -> Double {
        return try get(pos: pos) { (pos) in
            return Double(sqlite3_column_double(stmt, Int32(pos)))
        }
    }

    public func getString(pos: Int) throws -> String {
        return try get(pos: pos) { (pos) in
            guard let ptr = sqlite3_column_text(stmt, Int32(pos)) else {
                fatalError("Can't build string")
            }
            return String(cString: ptr)
        }
    }
    
    public func getData(pos: Int) throws -> Data {
        return try get(pos: pos) { (pos) in
            guard let ptr = sqlite3_column_blob(stmt, Int32(pos)) else {
                fatalError("Can't build data")
            }
            return Data(bytes: ptr, count: Int(sqlite3_column_bytes(stmt, Int32(pos))))
        }
    }
    
    public func isNull(pos: Int) throws -> Bool {
        return try get(pos: pos) { (pos) in
            return sqlite3_column_type(stmt, Int32(pos)) == SQLITE_NULL
        }
    }
    
    //MARK: private
    
    private func get<T>(pos: Int, onGet: (Int) throws -> T) throws -> T {
        try ensureNotReleased()
        try ensureHasData(at: pos)
        return try onGet(pos)
    }
    
    private func ensureHasData(at pos: Int) throws {
        guard hasData else {
            throw StatementError.noData
        }
        guard pos >= 0 && pos < selectColumsCount else {
            throw StatementError.indexOutOfRange
        }
    }
}
