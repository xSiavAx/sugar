import Foundation
import SSSugarCore

open class DBStoragingMock: SSMock, SSDBStoraging {
    public static var tables: [SSDBTable.Type] = []

    open var db: SSDataBaseProtocol {
        return try! call()
    }
    
    open func initializeStructure() throws {
        try call()
    }
    
    open func initializeStructure(strictExist: Bool) throws {
        try call(strictExist)
    }
    
    open func withinTransaction<T>(job: () throws -> T) throws -> T {
        do {
            let result = try job()
            return try call(result)
        } catch {
            let _ = try call() as T
            throw error
        }
    }
    
    open func withinSavePoint<T>(_ label: String, job: () throws -> T) throws -> T {
        do {
            let result = try job()
            return try call(label, result)
        } catch {
            let _ = try call(label) as T
            throw error
        }
    }
    
    // MARK: Expect
    
    open func expect(db: DataBaseMock, stmt: SSDataBaseStmtMock, query: String) {
        expectDB(db)
        db.expectStatement(stmt, query: query)
    }
    
    open func expect(db: DataBaseMock, stmt: SSDataBaseStmtMock, query: String, job: () -> Void) {
        expectDB(db)
        db.expectWithStmt(stmt: stmt, query: query, job: job)
    }
    
    open func expect(db: DataBaseMock, stmt: SSDataBaseStmtMock, query: String, job: (SSDataBaseStmtMockProcessor) -> Void) {
        expectDB(db)
        db.expectWithStmt(stmt: stmt, query: query, job: job)
    }

    @discardableResult
    open func expectDB(_ db: SSDataBaseProtocol) -> SSMockCallExpectation {
        return expect(result: db) { $0.db }
    }

    @discardableResult
    open func expectInitializeStructure() -> SSMockCallExpectation {
        expect { mock, args in try mock.initializeStructure() }
    }

    @discardableResult
    open func expectInitializeStructure(strictExist: Bool) -> SSMockCallExpectation {
        expect { try $0.initializeStructure(strictExist: $1.eq(strictExist)) }
    }
    
    @discardableResult
    open func expectWithinTransaction<T>(result: T, onMatch: @escaping (T, T) -> Bool) -> SSMockCallExpectation {
        return expect(result: result) { mock, args in
            try mock.withinTransaction() {
                args.match(result) {
                    guard let callResult = $1 as? T else { return false }
                    return onMatch($0, callResult)
                }
            }
        }
    }

    @discardableResult
    open func expectWithinTransaction<T: Equatable>(result: T) -> SSMockCallExpectation {
        return expect(result: result) { mock, args in
            try mock.withinTransaction() { args.eq(result) }
        }
    }
    
    @discardableResult
    open func expectWithinTransaction() -> SSMockCallExpectation {
        return expect { mock, args in
            try mock.withinTransaction() { args.capture(.init(dummy: ())) }
        }
    }
    
    @discardableResult
    open func expectWithinTransactionRethrows<T>(dummy: T) -> SSMockCallExpectation {
        return expect(result: dummy) {  mock in
            try mock.withinTransaction() { dummy }
        }
    }
    
    @discardableResult
    open func expectWithinTransactionRethrows() -> SSMockCallExpectation {
        return expectWithinTransactionRethrows(dummy: ())
    }
    
    @discardableResult
    open func expectWithinSavePoint<T: Equatable>(_ result: T, label: String) -> SSMockCallExpectation {
        return expect(result: result) {  mock, args in
            try mock.withinSavePoint(args.eq(label)) { args.eq(result) }
        }
    }

    @discardableResult
    open func expectWithinSavePoint(label: String) -> SSMockCallExpectation {
        return expect { mock, args in
            try mock.withinSavePoint(args.eq(label)) { args.capture(.init(dummy: ())) }
        }
    }
    
    @discardableResult
    open func expectWithinSavePointRethrows<T>(label: String, dummy: T) -> SSMockCallExpectation {
        return expect(result: dummy) { mock, args in
            try mock.withinSavePoint(args.eq(label)) { dummy }
        }
    }
    
    @discardableResult
    open func expectWithinSavePointRethrows(label: String) -> SSMockCallExpectation {
        return expectWithinSavePointRethrows(label: label, dummy: ())
    }
}
