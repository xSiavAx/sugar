public protocol SSTransacted {
    var isTransactionStarted : Bool {get}
    
    func beginTransaction() throws
    func commitTransaction() throws
    func cancelTransaction() throws
}

public extension SSTransacted {
    func finishTransaction(succcess: Bool) throws {
        if (succcess) {
            try commitTransaction()
        } else {
            try cancelTransaction()
        }
    }
}
