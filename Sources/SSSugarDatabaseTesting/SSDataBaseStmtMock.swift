import Foundation
import SSSugarCore
import SSSugarDatabase
import SSSugarTesting

open class SSDataBaseStmtMock: SSMock, SSDataBaseStatementProtocol {
    //MARK: - public
    
    @discardableResult
    open func expectBind<T: SSDBColTypeTesting>(_ col: T, pos: Int) -> SSMockCallExpectation {
        return expect() {
            try col.onBind(args: $1).bindTo(stmt: $0, pos: $1.eq(pos))
        }
    }

    @discardableResult
    open func expectGet<T: SSDBColTypeTesting>(_ col: T, pos: Int) -> SSMockCallExpectation {
        expect(result: col.onResult()) {
            try $0.get(pos: $1.eq(pos))
        }
    }
    
    open func expectGetOpt<T: SSDBColTypeTesting>(_ col: T?, pos: Int) {
        let isNill = col == nil
        
        expectIsNull(isNill, pos: pos)
        
        if (!isNill) {
            expect(result: col?.onResult()) {
                .some(try $0.get(pos: $1.eq(pos)))
            }
        }
    }
    
    @discardableResult
    open func expectIsNull(_ isNull: Bool, pos: Int) -> SSMockCallExpectation {
        expect(result: isNull, label: "test") { try $0.isNull(pos: $1.eq(pos)) }
    }
    
    @discardableResult
    open func expectSelect(_ result: Bool) -> SSMockCallExpectation {
        expect(result: result) { try $0.select() }
    }

    @discardableResult
    open func expectCommit() -> SSMockCallExpectation {
        expect() { try $0.commit() }
    }

    @discardableResult
    open func expectClear() -> SSMockCallExpectation {
        expect() { try $0.clear() }
    }

    @discardableResult
    open func expectReset() -> SSMockCallExpectation {
        expect() { try $0.reset() }
    }

    @discardableResult
    open func expectRelease() -> SSMockCallExpectation {
        expect() { try $0.release() }
    }
    
    //MARK: - SSDataBaseStatementProtocol
    
    open func bind(int: Int, pos: Int) throws {
        try super.call(int, pos)
    }
    
    open func bind(int64: Int64, pos: Int) throws {
        try super.call(int64, pos)
    }
    
    open func bind(double: Double, pos: Int) throws {
        try super.call(double, pos)
    }
    
    open func bind(string: String, pos: Int) throws {
        try super.call(string, pos)
    }
    
    open func bind(data: Data, pos: Int) throws {
        try super.call(data, pos)
    }
    
    open func bindNull(pos: Int) throws {
        try super.call(pos)
    }
    
    open func getInt(pos: Int) throws -> Int {
        try super.call(pos)
    }
    
    open func getInt64(pos: Int) throws -> Int64 {
        try super.call(pos)
    }
    
    open func getDouble(pos: Int) throws -> Double {
        try super.call(pos)
    }
    
    open func getString(pos: Int) throws -> String {
        try super.call(pos)
    }
    
    open func getData(pos: Int) throws -> Data {
        try super.call(pos)
    }
    
    open func isNull(pos: Int) throws -> Bool {
        try super.call(pos)
    }
    
    open func select() throws -> Bool {
        try super.call()
    }
    
    open func commit() throws {
        try super.call()
    }
    
    open func clear() throws {
        try super.call()
    }
    
    open func reset() throws {
        try super.call()
    }
    
    open func release() throws {
        try super.call()
    }
}
