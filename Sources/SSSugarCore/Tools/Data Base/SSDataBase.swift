import Foundation

#if canImport(SQLite3)
import SQLite3
#else
import CSQLiteSS
#endif

#warning("DB: Test")
//TODO: Add tests for every DB component

#warning("DB: DOCS")
//TODO: Add docs for every file from DB Structure

#warning("DB: Error msg")
//TODO: Add error messages to all DB exceptions (like cantCompile inside stmt)

public class SSDataBase {
    public let connection: SSDataBaseConnectionProtocol
    public let transactionController : SSDataBaseTransactionController
    public let statementsCache : SSDataBaseStatementCache
    
    public init(path: URL) {
        connection = SSDataBaseConnection(path: path)
        transactionController = SSDataBaseTransactionController()
        statementsCache = SSDataBaseStatementCache(statementsCreator: connection)
        
        transactionController.transactionCreator = self
        connection.open()
    }
    
    deinit {
        try? statementsCache.clearAll()
        if (connection.isOpen) {
            connection.close()
        }
    }
    
    public func stmtProcessor(query: String) throws -> SSDataBaseStatementProcessor {
        let stmt = try statement(forQuery: query)
        return SSDataBaseStatementProcessor(stmt)
    }
    
    public func exec(queries: [String]) throws {
        let doTransaction = !self.isTransactionStarted
        
        if (doTransaction) {
            try beginTransaction()
        }
        do {
            try queries.forEach(exec(query:))
        } catch {
            if (doTransaction) {
                try cancelTransaction()
            }
            throw error
        }
        if (doTransaction) {
            try commitTransaction()
        }
    }
}

//MARK: - Creating
extension SSDataBase {
    public enum BaseDir {
        case documents
        case current
        case custom(URL)
        
        var url: URL {
            switch self {
            case .documents:
                let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let base = URL(fileURLWithPath: dirPath)
                
                return base.appendingPathComponent("data_base")
            case .current:
                let base = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                
                return base.appendingPathComponent("data_base")
            case .custom(let url):
                return url
            }
        }
    }
    
    public static func dbWith(baseDir: BaseDir, name: String, prefix: String? = nil) throws -> SSDataBase {
        var path = baseDir.url
        
        if let prefix = prefix {
            path.appendPathComponent(prefix)
        }
        if (!FileManager.default.fileExists(atPath: path.path)) {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        }
        path.appendPathComponent("\(name).sqlite3")
        NSLog("Data Base path:\n\(path)")
        
        return SSDataBase(path: path)
    }
    
    #if os(iOS)
    public static func dbWith(name: String, prefix: String? = nil) throws -> SSDataBase {
        return try dbWith(baseDir: .documents, name: name, prefix: prefix)
    }
    #else
    public static func dbWith(name: String, prefix: String? = nil) throws -> SSDataBase {
        return try dbWith(baseDir: .current, name: name, prefix: prefix)
    }
    #endif
    
    public static func dbWith(baseDir: URL, name: String, prefix: String? = nil) throws -> SSDataBase {
        return try dbWith(baseDir: .custom(baseDir), name: name, prefix: prefix)
    }
}


//MARK: - SSDataBaseProtocol
extension SSDataBase: SSDataBaseProtocol {
    public func savePoint(withTitle: String) throws -> SSDataBaseSavePointProtocol {
        let sp = try SSDataBaseSavePoint(executor: self, title: withTitle)
        return try transactionController.registerSavePoint(sp)
    }
    
    public func lastInsrtedRowID() -> Int64 {
        connection.lastInsertedRowID()
    }
}

//MARK: SSTransacted

extension SSDataBase: SSTransacted {
    public var isTransactionStarted: Bool {
        return transactionController.isTransactionStarted
    }
    
    public func beginTransaction() throws {
        try transactionController.beginTransaction()
    }
    
    public func commitTransaction() throws {
        try transactionController.commitTransaction()
    }
    
    public func cancelTransaction() throws {
        try transactionController.cancelTransaction()
    }
}

//MARK: SSDataBaseStatementCreator

extension SSDataBase: SSDataBaseStatementCreator {
    public func statement(forQuery: String) throws -> SSDataBaseStatementProtocol {
        let statement = try statementsCache.statement(query: forQuery)
        return try transactionController.registerStatement(statement)
    }
}

//MARK: - SSDataBaseTransactionCreator

extension SSDataBase: SSDataBaseTransactionCreator {
    public func createTransaction() throws -> SSDataBaseTransaction {
        return try SSDataBaseTransaction(executor: self)
    }
}

//MARK: - SSDataBaseQueryExecutor

extension SSDataBase: SSDataBaseQueryExecutor {
    public func exec(query: String) throws {
        let stmt = try statementsCache.statement(query: query)
        
        try stmt.commit()
        try stmt.release()
    }
}

//MARK: - SSCacheContainer

extension SSDataBase: SSCacheContainer {
    public func fitCache() {
        statementsCache.clearOld()
    }
    
    public func clearCache() throws {
        try statementsCache.clearAll()
    }
}

