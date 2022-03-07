import Foundation
import SSSugarCore

open class DataBaseMock: SSMock, SSDataBaseProtocol {
    open var isTransactionStarted: Bool { try! call() }
    
    open func expectWithStmt(stmt: SSDataBaseStmtMock, query: String, job: () -> Void) {
        expectStatement(stmt, query: query)
        job()
        stmt.expectRelease()
    }
    
    open func expectWithStmt(stmt: SSDataBaseStmtMock, query: String, job: (SSDataBaseStmtMockProcessor) -> Void) {
        let binder = SSDataBaseStmtMockProcessor(stmt: stmt)
        
        expectStatement(stmt, query: query)
        job(binder)
        stmt.expectRelease()
    }

    open func stmtProcessor(query: String) throws -> SSDataBaseStatementProcessor {
        try call(query)
    }

    open func exec(queries: [String]) throws {
        try call(queries)
    }

    open func transacted(queries: [String]) throws {
        try call(queries)
    }

    open func savePoint(withTitle title: String) throws -> SSDataBaseSavePointProtocol {
        return try call(title)
    }

    open func lastInsrtedRowID() -> Int64 {
        return try! call()
    }

    open func createTransaction() throws -> SSDataBaseTransaction {
        return try call()
    }

    open func beginTransaction() throws {
        try call()
    }

    open func commitTransaction() throws {
        try call()
    }

    open func cancelTransaction() throws {
        try call()
    }

    open func statement(forQuery query: String) throws -> SSDataBaseStatementProtocol {
        return try call(query)
    }

    open func exec(query: String) throws {
        try call(query)
    }

    open func fitCache() {
        try! call()
    }

    open func clearCache() throws {
        try call()
    }

    // MARK: Expect

    @discardableResult
    open func expectStmtProcessor(result: SSDataBaseStatementProcessor, query: String) -> SSMockCallExpectation {
        return expect(result: result) { try $0.stmtProcessor(query: $1.eq(query)) }
    }

    @discardableResult
    open func expectExec(queries: [String]) -> SSMockCallExpectation {
        return expect { try $0.exec(queries: $1.eq(queries)) }
    }

    open func expectTransacted(queries: [String]) -> SSMockCallExpectation {
        return expect { try $0.transacted(queries: $1.eq(queries)) }
    }

    @discardableResult
    open func expectSavePoint(result: SSDataBaseSavePointProtocol, withTitle title: String) -> SSMockCallExpectation {
        return expect(result: result) { try $0.savePoint(withTitle: $1.eq(title)) }
    }

    @discardableResult
    open func expectLastInsertedRowID(result: Int64) -> SSMockCallExpectation {
        return expect(result: result) { $0.lastInsrtedRowID() }
    }

    @discardableResult
    func expectCreateTransaction(result: SSDataBaseTransaction) -> SSMockCallExpectation {
        return expect(result: result) { try $0.createTransaction() }
    }

    @discardableResult
    open func expectBeginTransaction() -> SSMockCallExpectation {
        return expect { try $0.beginTransaction() }
    }

    @discardableResult
    open func expectCommitTransaction() -> SSMockCallExpectation {
        return expect { try $0.commitTransaction() }
    }

    @discardableResult
    open func expectCancelTransaction() -> SSMockCallExpectation {
        return expect { try $0.cancelTransaction() }
    }

    @discardableResult
    open func expectStatement(_ stmt: SSDataBaseStatementProtocol, query: String) -> SSMockCallExpectation {
        return expect(result: stmt) { try $0.statement(forQuery: $1.eq(query)) }
    }

    @discardableResult
    open func expectExec(query: String) -> SSMockCallExpectation {
        return expect { try $0.exec(query: $1.eq(query)) }
    }

    @discardableResult
    open func expectFitCache() -> SSMockCallExpectation {
        return expect { $0.fitCache() }
    }

    @discardableResult
    open func expectClearCache() -> SSMockCallExpectation {
        return expect { try $0.clearCache() }
    }
}
