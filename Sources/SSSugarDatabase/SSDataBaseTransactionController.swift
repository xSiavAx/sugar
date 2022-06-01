import Foundation
import SSSugarCore

public protocol SSDataBaseTransactionControllerProtocol : SSTransacted {
    func registerStatement(_ stmt: () throws -> SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol
    func registerSavePoint(_ sp: () throws -> SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol
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
    public func registerStatement(_ stmt: () throws -> SSDataBaseStatementProtocol) throws -> SSDataBaseStatementProtocol {
        try ensureStarted()
        let statement = try stmt() //We accepts closure (instead of just stmt) to do check before statemnt does actually create
        
        return SSReleaseDecorator(decorated: SSDataBaseStatementProxy(statement),
                                  onCreate: {[weak self] in self?.didRegister(stmt: $0)},
                                  onRelease: {[weak self] in self?.didRelease(stmt: $0) ?? true})
    }
    
    public func registerSavePoint(_ sp: () throws -> SSDataBaseSavePointProtocol) throws -> SSDataBaseSavePointProtocol {
        try ensureStarted()
        let savePoint = try sp() //We accepts closure (instead of just savepoint) to do check before savepoint does actually create
        
        return SSReleaseDecorator(decorated: SSDataBaseSavePointProxy(savePoint: savePoint),
                                  onCreate: {[weak self] in self?.didRegister(sp: $0)},
                                  onRelease: {[weak self] in self?.didRelease(sp: $0) ?? true})
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
