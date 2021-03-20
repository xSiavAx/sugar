import Foundation

public class SSDataBaseStatementProcessor {
    public var bindIndex = 0
    public var getIndex = 0
    public let statement : SSDataBaseStatementProtocol
    
    public init(_ mStmt: SSDataBaseStatementProtocol) {
        statement = mStmt
    }
    
    public func bind<T: SSDBColType>(_ val: T) throws {
        try bind(val: val, pos: bindIndex)
        bindIndex += 1
    }
    
    public func get<T: SSDBColType>() throws -> T {
        defer { getIndex += 1 }
        return try get(pos: getIndex)
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
