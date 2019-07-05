import Foundation

public class SSDataBase {
    let connection: SSDataBaseConnectionProtocol
    let transactionController : SSDataBaseTransactionController
    
    init(path: URL) {
        connection = SSDataBaseConnection(path: path)
        transactionController = SSDataBaseTransactionController()
        
        transactionController.transactionCreator = self
    }
}

//MARK: - SSDataBaseProtocol
extension SSDataBase: SSDataBaseProtocol {
    public func createSavePoint(withTitle: String) -> SSDataBaseSavePointProtocol {
        
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
    public func statement(forQuery: String) -> SSDataBaseStatementProtocol {
        
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
        let stmt = statement(forQuery: query)
        
        do {try stmt.commit()} catch { fatalError("\(error)") }
        stmt.release()
    }
}

