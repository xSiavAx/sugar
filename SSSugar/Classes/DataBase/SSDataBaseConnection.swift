import Foundation
import SQLite3

public protocol SSDataBaseStatementCompiler {
    func compileStatement(query: String) throws -> SSDataBaseStatementProtocol?
}

public protocol SSDataBaseConnectionProtocol: SSDataBaseStatementCompiler {
    var isOpen : Bool {get}
    func open()
    func close()
}

public class SSDataBaseConnection {
    public private(set) var isOpen = false
    private (set) var db: OpaquePointer!
    let pathUrl : URL
    
    init(path: URL) {
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
    
    public func compileStatement(query: String) throws -> SSDataBaseStatementProtocol? {
        return try SSDataBaseStatement(query: query, db: db)
    }
}


