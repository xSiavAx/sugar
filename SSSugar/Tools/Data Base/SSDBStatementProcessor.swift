import Foundation

public class SSDataBaseStatementProcessor {
    public var bindIndex = 0
    public var getIndex = 0
    public let statement : SSDataBaseStatementProtocol
    
    public init(_ mStmt: SSDataBaseStatementProtocol) {
        statement = mStmt
    }
    
    public func bind(int: Int) throws {
        try bind(int:int, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(int: Int?) throws {
        try bind(int: int, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(int64: Int64) throws {
        try bind(int64:int64, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(int64: Int64?) throws {
        try bind(int64: int64, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(double: Double) throws {
        try bind(double:double, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(double: Double?) throws {
        try bind(double: double, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(string: String) throws {
        try bind(string:string, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(string: String?) throws {
        try bind(string: string, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(data: Data) throws {
        try bind(data:data, pos: bindIndex)
        bindIndex += 1
    }

    public func bind(data: Data?) throws {
        try bind(data: data, pos: bindIndex)
        bindIndex += 1
    }

    public func getInt() throws -> Int {
        defer { getIndex += 1; }
        return try getInt(pos: getIndex)
    }

    public func getIntOp() throws -> Int? {
        defer { getIndex += 1; }
        return try getIntOp(pos: getIndex)
    }

    public func getInt64() throws -> Int64 {
        defer { getIndex += 1; }
        return try getInt64(pos: getIndex)
    }

    public func getInt64Op() throws -> Int64? {
        defer { getIndex += 1; }
        return try getInt64Op(pos: getIndex)
    }

    public func getDouble() throws -> Double {
        defer { getIndex += 1; }
        return try getDouble(pos: getIndex)
    }

    public func getDouble() throws -> Double? {
        defer { getIndex += 1; }
        return try getDoubleOp(pos: getIndex)
    }

    public func getString() throws -> String {
        defer { getIndex += 1; }
        return try getString(pos: getIndex)
    }

    public func getStringOp() throws -> String? {
        defer { getIndex += 1; }
        return try getStringOp(pos: getIndex)
    }

    public func getData() throws -> Data {
        defer { getIndex += 1; }
        return try getData(pos: getIndex)
    }

    public func getDataOp() throws -> Data? {
        defer { getIndex += 1; }
        return try getDataOp(pos: getIndex)
    }
}

extension SSDataBaseStatementProcessor: SSDataBaseStatementProxing {
    public func select() throws -> Bool {
        getIndex = 0
        bindIndex = 0
        return try statement.select()
    }
    
    public func commit() throws {
        getIndex = 0
        bindIndex = 0
        try statement.commit()
    }
    
    public func clear() throws {
        bindIndex = 0
        try statement.clear()
    }
}
