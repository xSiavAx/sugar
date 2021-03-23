import Foundation
import SQLite3

public protocol SSDataBaseConnectionProtocol: SSDataBaseStatementCreator {
    var isOpen : Bool {get}
    func open()
    func close()
    
    func lastInsertedRowID() -> Int64
}

public class SSDataBaseConnection {
    public private(set) var isOpen = false
    private (set) var db: OpaquePointer!
    public let pathUrl : URL
    
    public init(path: URL) {
        pathUrl = path
    }
}

extension SSDataBaseConnection: SSDataBaseConnectionProtocol {
    public func open() {
        guard sqlite3_open(pathUrl.path, &db) == SQLITE_OK else {
            fatalError("Can't open database at \(pathUrl)")
        }
        isOpen = true
    }
    
    public func close() {
        sqlite3_close(db)
        isOpen = false
    }
    
    public func statement(forQuery: String) throws -> SSDataBaseStatementProtocol {
        return try SSDataBaseStatement(query: forQuery, db: db)
    }
    
    public func lastInsertedRowID() -> Int64 {
        return sqlite3_last_insert_rowid(db)
    }
}


