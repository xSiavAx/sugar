public protocol SSTransacted {
    var isTransactionStarted : Bool {get}
    
    func beginTransaction() throws
    func commitTransaction() throws
    func cancelTransaction() throws
}
