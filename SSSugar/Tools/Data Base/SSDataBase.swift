import Foundation

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
        if (connection.isOpen) {
            connection.close()
        }
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

//MARK: - SSDataBaseProtocol
extension SSDataBase: SSDataBaseProtocol {
    public func savePoint(withTitle: String) throws -> SSDataBaseSavePointProtocol {
        let sp = try SSDataBaseSavePoint(executor: self, title: withTitle)
        return try transactionController.registerSavePoint(sp)
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

