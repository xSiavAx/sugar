import Foundation
import SQLite3

//Error's code list
//https://www.sqlite.org/rescode.html

/// Bind and get starts from zero
public class SSDataBaseStatement {
    public enum IError: Error {
        case cantCompile(sqliteCode: Int, msg: String)
        case outOfMemory
        case commitError(sqliteCode: Int)
    }
    private (set) var stmt: OpaquePointer!
    
    public init(query: String, db: OpaquePointer) throws {
        let result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
        
        guard result == SQLITE_OK else {
            throw IError.cantCompile(sqliteCode: Int(result), msg:String(cString: sqlite3_errmsg(db)))
        }
    }
}

extension SSDataBaseStatement : SSDataBaseStatementProtocol {
    static let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    static let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    public func bind(int: Int, pos: Int) {
        guard sqlite3_bind_int(stmt, Int32(pos+1), Int32(int)) == SQLITE_OK else {
            fatalError("Can't bind value")
        }
    }
    
    public func bind(int64: Int64, pos: Int) {
        guard sqlite3_bind_int64(stmt, Int32(pos+1), int64) == SQLITE_OK else {
            fatalError("Can't bind value")
        }
    }
    
    public func bind(double: Double, pos: Int) {
        guard sqlite3_bind_double(stmt, Int32(pos+1), double) == SQLITE_OK else {
            fatalError("Can't bind value")
        }
    }
    
    public func bind(string: String, pos: Int) {
        guard sqlite3_bind_text(stmt, Int32(pos+1), string, -1, SSDataBaseStatement.SQLITE_TRANSIENT) == SQLITE_OK else {
            fatalError("Can't bind value")
        }
    }
    
    public func bind(data: Data, pos: Int) {
        //TODO: Remake it after Swift 5.1 migration
        let result = data.withUnsafeBytes { sqlite3_bind_blob(stmt, Int32(pos+1), $0, Int32(data.count), SSDataBaseStatement.SQLITE_TRANSIENT) }
        
        guard result == SQLITE_OK else {
            fatalError("Can't bind value")
        }
    }
    
    public func bindNull(pos: Int) {
        guard sqlite3_bind_null(stmt, Int32(pos+1)) == SQLITE_OK else {
            fatalError("Can't bind null")
        }
    }
    
    public func getInt(pos: Int) -> Int {
        return Int(sqlite3_column_int(stmt, Int32(pos)))
    }
    
    public func getIntOp(pos: Int) -> Int? {
        getOptional(pos: pos, onNotNull: getInt(pos:))
    }
    
    public func getInt64(pos: Int) -> Int64 {
        return Int64(sqlite3_column_int64(stmt, Int32(pos)))
    }
    
    public func getInt64Op(pos: Int) -> Int64? {
        getOptional(pos: pos, onNotNull: getInt64(pos:))
    }
    
    public func getDouble(pos: Int) -> Double {
        return Double(sqlite3_column_double(stmt, Int32(pos)))
    }
    
    public func getDoubleOp(pos: Int) -> Double? {
        getOptional(pos: pos, onNotNull: getDouble(pos:))
    }
    
    public func getString(pos: Int) -> String? {
        guard let ptr = sqlite3_column_text(stmt, Int32(pos)) else {
            return nil
        }
        return String(cString: ptr)
    }
    
    public func getData(pos: Int) -> Data? {
        guard let ptr = sqlite3_column_blob(stmt, Int32(pos)) else {
            return nil
        }
        return Data(bytes: ptr, count: Int(sqlite3_column_bytes(stmt, Int32(pos))))
    }
    
    public func select() -> Bool {
        return sqlite3_step(stmt) == SQLITE_ROW
    }
    
    public func commit() throws {
        let result = sqlite3_step(stmt)
        
        sqlite3_reset(stmt)
        
        guard result != SQLITE_OK else {
            if (result == SQLITE_FULL) {
                throw IError.outOfMemory
            }
            throw IError.commitError(sqliteCode: Int(result))
        }
    }
    
    public func clear() {
        sqlite3_clear_bindings(stmt)
    }
    
    public func release() {
        sqlite3_finalize(stmt)
    }
    
    private func getOptional<T>(pos: Int, onNotNull: (Int)->T) -> T? {
        guard typeIsNotNull(pos: pos) else { return nil }
        return onNotNull(pos)
    }
    
    private func typeIsNotNull(pos: Int) -> Bool {
        return sqlite3_column_type(stmt, Int32(pos)) != SQLITE_NULL
    }
}
