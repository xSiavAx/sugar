import Foundation

#warning("DB: Error msg")
//TODO: Add error messages to all DB exceptions (like cantCompile inside stmt)

public class SSDataBase {
    let connection: SSDataBaseConnectionProtocol
    let transactionController : SSDataBaseTransactionController
    let statementsCache : SSDataBaseStatementCache
    
    public init(path: URL) {
        connection = SSDataBaseConnection(path: path)
        transactionController = SSDataBaseTransactionController()
        statementsCache = SSDataBaseStatementCache(statementsCreator: connection)
        
        transactionController.transactionCreator = self
        connection.open()
    }
}

//MARK: - SSDataBaseProtocol
extension SSDataBase: SSDataBaseProtocol {
    public func savePoint(withTitle: String) throws -> SSDataBaseSavePointProtocol {
        let sp = SSDataBaseSavePoint(executor: self, title: withTitle)
        
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
        return try statementsCache.statement(query: forQuery)
    }
}

//MARK: - SSDataBaseTransactionCreator

extension SSDataBase: SSDataBaseTransactionCreator {
    func createTransaction() -> SSDataBaseTransaction {
        return SSDataBaseTransaction(executor: self)
    }
}

//MARK: - SSDataBaseTransactionCreator

extension SSDataBase: SSDataBaseQueryExecutor {
    func exec(query: String) {
        do {
            let stmt = try statement(forQuery: query)
            
            try stmt.commit()
            try stmt.release()
        } catch { fatalError("\(error)") }
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

