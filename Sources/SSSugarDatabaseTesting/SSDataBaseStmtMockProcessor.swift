import Foundation
import SSSugarDatabase
import SSSugarTesting

open class SSDataBaseStmtMockProcessor {
    open var stmt: SSDataBaseStmtMock
    open var bindPos: Int = 0
    open var getPos: Int = 0
    
    public init(stmt: SSDataBaseStmtMock) {
        self.stmt = stmt
    }
    
    @discardableResult
    open func expectBind<T: SSDBColTypeTesting>(_ col: T) -> SSMockCallExpectation {
        defer { bindPos += 1 }
        return stmt.expectBind(col, pos: bindPos)
    }
    
    @discardableResult
    open func expectGet<T: SSDBColTypeTesting>(_ col: T) -> SSMockCallExpectation {
        defer { getPos += 1 }
        return stmt.expectGet(col, pos: getPos)
    }
    
    open func expectGetOpt<T: SSDBColTypeTesting>(_ col: T?) {
        defer { getPos += 1 }
        stmt.expectGetOpt(col, pos: getPos)
    }
    
    @discardableResult
    open func expectCommit() -> SSMockCallExpectation {
        getPos = 0
        bindPos = 0
        return stmt.expectCommit()
    }
    
    @discardableResult
    open func expectSelect(_ result: Bool) -> SSMockCallExpectation {
        getPos = 0
        bindPos = 0
        return stmt.expectSelect(result)
    }
    
    @discardableResult
    open func expectClear() -> SSMockCallExpectation {
        getPos = 0
        bindPos = 0
        return stmt.expectClear()
    }
}
