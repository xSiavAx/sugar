import Foundation

public class SSDataBaseStatementProcessor {
    var bindIndex = 0
    var getIndex = 0
    let statement : SSDataBaseStatementProtocol
    
    public init(_ mStmt: SSDataBaseStatementProtocol) {
        statement = mStmt
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

extension SSDataBaseStatementProcessor : SSDataBaseStatementProxing {
    public func select() -> Bool {
        getIndex = 0
        bindIndex = 0
        return statement.select()
    }
    
    public func commit() throws {
        getIndex = 0
        bindIndex = 0
        try statement.commit()
    }
    
    public func clear() {
        bindIndex = 0
        statement.clear()
    }
}

