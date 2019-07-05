import Foundation

protocol SSDataBaseQueryExecutor : AnyObject {
    func exec(query: String)
}

class SSDataBaseTransaction {
    unowned let executor : SSDataBaseQueryExecutor
    private var closed = false
    
    enum mError: Error {
        case transactionAlreadyClosed
    }
    
    init(executor mExecutor: SSDataBaseQueryExecutor) {
        executor = mExecutor
        executor.exec(query: "begin transaction;")
    }
    
    deinit {
        guard closed else {
            fatalError("Transaction hasn't been closed.")
        }
    }
    
    //MARK: - public
    func commit() throws {
        try ensureOpen()
        executor.exec(query:"commit transaction;")
        closed = true
    }
    
    func cancel() throws {
        try ensureOpen()
        executor.exec(query:"rollback transaction;")
        closed = true
    }
    
    //MARK: - private
    func ensureOpen() throws {
        guard !closed else {
            throw mError.transactionAlreadyClosed
        }
    }
}
