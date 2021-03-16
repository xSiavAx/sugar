import Foundation

protocol SSDataBaseStatementProxing: SSDataBaseStatementProtocol {
    var statement : SSDataBaseStatementProtocol {get}
}

extension SSDataBaseStatementProxing {
    public func bind(int: Int, pos: Int) throws {
        try statement.bind(int:int, pos:pos)
    }

    public func bind(int64: Int64, pos: Int) throws {
        try statement.bind(int64:int64, pos:pos)
    }
    
    public func bind(double: Double, pos: Int) throws {
        try statement.bind(double:double, pos:pos)
    }

    public func bind(string: String, pos: Int) throws {
        try statement.bind(string:string, pos:pos)
    }
    
    public func bind(data: Data, pos: Int) throws {
        try statement.bind(data:data, pos:pos)
    }

    public func bindNull(pos: Int) throws {
        try statement.bindNull(pos: pos)
    }

    public func getInt(pos: Int) throws -> Int {
        return try statement.getInt(pos: pos)
    }
    
    public func getInt64(pos: Int) throws -> Int64 {
        return try statement.getInt64(pos:pos)
    }
    
    public func getDouble(pos: Int) throws -> Double {
        return try statement.getDouble(pos:pos)
    }

    public func getString(pos: Int) throws -> String {
        return try statement.getString(pos:pos)
    }

    public func getData(pos: Int) throws -> Data {
        return try statement.getData(pos:pos)
    }
    
    public func isNull(pos: Int) throws -> Bool {
        return try statement.isNull(pos: pos)
    }

    public func select() throws -> Bool {
        return try statement.select()
    }
    
    public func commit() throws {
        try statement.commit()
    }
    
    public func clear() throws {
        try statement.clear()
    }
    
    public func release() throws {
        try statement.release()
    }
}

public struct SSDataBaseStatementProxy: SSDataBaseStatementProxing {
    let statement: SSDataBaseStatementProtocol
}
