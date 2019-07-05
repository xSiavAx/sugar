import Foundation

protocol SSDataBaseTransactionControllerProtocol : SSTransacted {
    func registerStatement(_ stmt: SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol
    func registerSavePoint(_ stmt: SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol
}

protocol SSDataBaseTransactionCreator: AnyObject {
    func createTransaction() -> SSDataBaseTransaction
}

class SSDataBaseTransactionController {
    enum mError: Error {
        case alreadyStarted
        case alreadyFinished
        case statemtnsHasnRelease
        case savePointsHasnRelease
    }
    
    private(set) var statemetnsCount = 0
    private(set) var savePointsCount = 0
    private(set) var transaction : SSDataBaseTransaction?
    unowned var transactionCreator : SSDataBaseTransactionCreator!
    
    //MARK: - private
    func didRegister(stmt: SSDataBaseStatementProtocol) {
        statemetnsCount += 1
    }
    
    func didRegister(sp: SSDataBaseSavePointProtocol) {
        savePointsCount += 1
    }
    
    func didRelease(stmt: SSDataBaseStatementProtocol) {
        statemetnsCount -= 1
    }
    
    func didRelease(sp: SSDataBaseSavePointProtocol) {
        savePointsCount -= 1
    }
}


//MARK: - SSDataBaseTransactionControllerProtocol
extension SSDataBaseTransactionController: SSDataBaseTransactionControllerProtocol {
    func registerStatement(_ stmt: SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol {
        try ensureStarted()
        return SSDataBaseStatementReleaseDecorator(statement: stmt, onCreate: didRegister(stmt:), onRelease: didRelease(stmt:))
    }
    
    func registerSavePoint(_ sp: SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol {
        try ensureStarted()
        return SSDataBaseSavePointReleaseDecorator(savePoint: sp, onCreate: didRelease(sp:), onRelease: didRelease(sp:))
    }
}

//MARK: SSTransacted
extension SSDataBaseTransactionController : SSTransacted {
    var isTransactionStarted: Bool { return !(transaction === nil) }
    
    func beginTransaction() throws {
        try ensureCanStart()
        transaction = transactionCreator.createTransaction()
    }
    
    func commitTransaction() throws {
        try ensureCanClose()
        do { try transaction?.commit() } catch { fatalError("\(error)") }
        transaction = nil
    }
    
    func cancelTransaction() throws {
        try ensureCanClose()
        do { try transaction?.cancel() } catch { fatalError("\(error)") }
        transaction = nil
    }
    
    //MARK: - private
    private func ensureCanStart() throws {
        guard !isTransactionStarted else {
            throw mError.alreadyStarted
        }
    }
    
    private func ensureCanClose() throws {
        try ensureStarted()
        try ensureCountersIsNull()
    }
    
    private func ensureStarted() throws {
        guard isTransactionStarted else {
            throw mError.alreadyFinished
        }
    }
    
    private func ensureCountersIsNull() throws {
        guard statemetnsCount == 0 else {
            throw mError.statemtnsHasnRelease
        }
        guard savePointsCount == 0 else {
            throw mError.savePointsHasnRelease
        }
    }
}
