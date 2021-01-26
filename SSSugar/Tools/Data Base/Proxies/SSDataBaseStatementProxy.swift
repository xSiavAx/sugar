import Foundation

protocol SSDataBaseStatementProxing : SSDataBaseStatementProtocol {
    var statement : SSDataBaseStatementProtocol {get}
}

extension SSDataBaseStatementProxing {
    public func bind(int: Int, pos: Int) {
        statement.bind(int:int, pos:pos)
    }
    public func bind(int64: Int64, pos: Int) {
        statement.bind(int64:int64, pos:pos)
    }
    
    public func bind(double: Double, pos: Int) {
        statement.bind(double:double, pos:pos)
    }
    
    public func bind(string: String, pos: Int) {
        statement.bind(string:string, pos:pos)
    }
    
    public func bind(data: Data, pos: Int) {
        statement.bind(data:data, pos:pos)
    }
    
    public func getInt(pos: Int) -> Int {
        return statement.getInt(pos:pos)
    }
    
    public func getInt64(pos: Int) -> Int64 {
        return statement.getInt64(pos:pos)
    }
    
    public func getDouble(pos: Int) -> Double {
        return statement.getDouble(pos:pos)
    }
    
    public func getString(pos: Int) -> String? {
        return statement.getString(pos:pos)
    }
    
    public func getData(pos: Int) -> Data {
        return statement.getData(pos:pos)
    }
    
    public func select() -> Bool {
        return statement.select()
    }
    
    public func commit() throws {
        try statement.commit()
    }
    
    public func clear() {
        statement.clear()
    }
    
    public func release() throws {
        print("\(self) proxing release to \(statement)")
        try statement.release()
    }
}

struct SSDataBaseStatementProxy : SSDataBaseStatementProxing {
    let statement: SSDataBaseStatementProtocol
}
