import Foundation

public class SSDataBase {
    let connection: SSDataBaseConnectionProtocol
    
    init(path: URL) {
        connection = SSDataBaseConnection(path: path)
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
        
    }
    
    public func beginTransaction() {
        
    }
    
    public func commitTransaction() {
        
    }
    
    public func cancelTransaction() {
        
    }
}

//MARK: SSDataBaseStatementCreator

extension SSDataBase: SSDataBaseStatementCreator {
    public func statement(forQuery: String) -> SSDataBaseStatementProtocol {
        
    }
}

