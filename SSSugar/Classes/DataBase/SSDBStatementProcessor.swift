import Foundation

public class SSDataBaseStatementProcessor {
    var bindIndex = 0
    var getIndex = 0
    private let stmt : SSDataBaseStatementProtocol
    
    public init(_ mStmt: SSDataBaseStatementProtocol) {
        stmt = mStmt
    }
    
    public func bind(int: Int) {
        bind(int:int, pos:bindIndex)
        bindIndex += 1
    }
    
    public func bind(int64: Int64) {
        bind(int64:int64, pos:bindIndex)
        bindIndex += 1
    }
    
    public func bind(double: Double) {
        bind(double:double, pos:bindIndex)
        bindIndex += 1
    }
    
    public func bind(string: String) {
        bind(string:string, pos:bindIndex)
        bindIndex += 1
    }
    
    public func bind(data: Data) {
        bind(data:data, pos:bindIndex)
        bindIndex += 1
    }
    
    public func getInt() -> Int {
        let val = getInt(pos:getIndex)
        getIndex += 1;
        
        return val
    }
    
    public func getInt64() -> Int64 {
        let val = getInt64(pos:getIndex)
        getIndex += 1;
        
        return val
    }
    
    public func getDouble() -> Double {
        let val = getDouble(pos:getIndex)
        getIndex += 1;
        
        return val
    }
    
    public func getString() -> String? {
        let val = getString(pos:getIndex)
        getIndex += 1;
        
        return val
    }
    
    public func getData() -> Data {
        let val = getData(pos:getIndex)
        getIndex += 1;
        
        return val
    }
}

extension SSDataBaseStatementProcessor : SSDataBaseStatementProtocol {
    public func bind(int: Int, pos: Int) {
        stmt.bind(int: int, pos: pos)
    }
    
    public func bind(int64: Int64, pos: Int) {
        stmt.bind(int64: int64, pos: pos)
    }
    
    public func bind(double: Double, pos: Int) {
        stmt.bind(double: double, pos: pos)
    }
    
    public func bind(string: String, pos: Int) {
        stmt.bind(string: string, pos: pos)
    }
    
    public func bind(data: Data, pos: Int) {
        stmt.bind(data: data, pos: pos)
    }
    
    public func getInt(pos: Int) -> Int {
        return stmt.getInt(pos:pos)
    }
    
    public func getInt64(pos: Int) -> Int64 {
        return stmt.getInt64(pos:pos)
    }
    
    public func getDouble(pos: Int) -> Double {
        return stmt.getDouble(pos:pos)
    }
    
    public func getString(pos: Int) -> String? {
        return stmt.getString(pos:pos)
    }
    
    public func getData(pos: Int) -> Data {
        return stmt.getData(pos:pos)
    }
    
    public func select() -> Bool {
        getIndex = 0
        bindIndex = 0
        return stmt.select()
    }
    
    public func commit() throws {
        getIndex = 0
        bindIndex = 0
        try stmt.commit()
    }
    
    public func clear() {
        bindIndex = 0
        stmt.clear()
    }
    
    public func release() {
        stmt.release()
    }
}
