import Foundation

public protocol SSDataBaseTransactionControllerProtocol : SSTransacted {
    func registerStatement(_ stmt: SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol
    func registerSavePoint(_ stmt: SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol
}

public protocol SSDataBaseTransactionCreator: AnyObject {
    func createTransaction() throws -> SSDataBaseTransaction
}

public class SSDataBaseTransactionController {
    public enum mError: Error {
        case alreadyStarted
        case noTransactionStarted
        case statemtnsHasnRelease
        case savePointsHasnRelease
    }
    
    private(set) var statemetnsCount = 0
    private(set) var savePointsCount = 0
    private(set) var transaction : SSDataBaseTransaction?
    public unowned var transactionCreator : SSDataBaseTransactionCreator!
    
    //MARK: - private
    private func didRegister(stmt: SSDataBaseStatementProtocol) {
        statemetnsCount += 1
    }
    
    private func didRegister(sp: SSDataBaseSavePointProtocol) {
        savePointsCount += 1
    }
    
    private func didRelease(stmt: SSDataBaseStatementProtocol) -> Bool {
        statemetnsCount -= 1
        return true
    }
    
    private func didRelease(sp: SSDataBaseSavePointProtocol) -> Bool {
        savePointsCount -= 1
        return true
    }
}


//MARK: - SSDataBaseTransactionControllerProtocol
extension SSDataBaseTransactionController: SSDataBaseTransactionControllerProtocol {
    public func registerStatement(_ stmt: SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol {
        try ensureStarted()
        return SSReleaseDecorator(decorated: SSDataBaseStatementProxy(statement: stmt), onCreate: didRegister(stmt:), onRelease: didRelease(stmt:))
    }
    
    public func registerSavePoint(_ sp: SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol {
        try ensureStarted()
        return SSReleaseDecorator(decorated: SSDataBaseSavePointProxy(savePoint: sp), onCreate: didRegister(sp:), onRelease: didRelease(sp:))
    }
}

//MARK: SSTransacted
extension SSDataBaseTransactionController : SSTransacted {
    public var isTransactionStarted: Bool { return !(transaction === nil) }
    
    public func beginTransaction() throws {
        try ensureCanStart()
        transaction = try transactionCreator.createTransaction()
    }
    
    public func commitTransaction() throws {
        try ensureCanClose()
        do { try transaction?.commit() } catch { fatalError("\(error)") }
        transaction = nil
    }
    
    public func cancelTransaction() throws {
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
            throw mError.noTransactionStarted
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
