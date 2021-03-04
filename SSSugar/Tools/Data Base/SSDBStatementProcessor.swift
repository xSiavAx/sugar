import Foundation

public class SSDataBaseStatementProcessor {
    public var bindIndex = 0
    public var getIndex = 0
    public let statement : SSDataBaseStatementProtocol
    
    public init(_ mStmt: SSDataBaseStatementProtocol) {
        statement = mStmt
    }
    
    public func bind(int: Int) {
        bind(int:int, pos: bindIndex)
        bindIndex += 1
    }
    
    public func bind(int: Int?) {
        bindOpt(val: int, onRegular: bind(int:))
    }
    
    public func bind(int64: Int64) {
        bind(int64:int64, pos: bindIndex)
        bindIndex += 1
    }
    public func bind(int64: Int64?) {
        bindOpt(val: int64, onRegular: bind(int64:))
    }
    
    public func bind(double: Double) {
        bind(double:double, pos: bindIndex)
        bindIndex += 1
    }
    
    public func bind(double: Double?) {
        bindOpt(val: double, onRegular: bind(double:))
    }
    
    public func bind(string: String) {
        bind(string:string, pos: bindIndex)
        bindIndex += 1
    }
    
    public func bind(string: String?) {
        bindOpt(val: string, onRegular: bind(string:))
    }
    
    public func bind(data: Data) {
        bind(data:data, pos: bindIndex)
        bindIndex += 1
    }
    
    public func bind(data: Data?) {
        bindOpt(val: data, onRegular: bind(data:))
    }
    
    public func getInt() -> Int {
        defer { getIndex += 1; }
        return getInt(pos: getIndex)
    }
    
    public func getIntOp() -> Int? {
        defer { getIndex += 1; }
        return getIntOp(pos: getIndex)
    }
    
    public func getInt64() -> Int64 {
        defer { getIndex += 1; }
        return getInt64(pos: getIndex)
    }
    
    public func getInt64Op() -> Int64? {
        defer { getIndex += 1; }
        return getInt64Op(pos: getIndex)
    }
    
    public func getDouble() -> Double {
        defer { getIndex += 1; }
        return getDouble(pos: getIndex)
    }
    
    public func getDouble() -> Double? {
        defer { getIndex += 1; }
        return getDoubleOp(pos: getIndex)
    }
    
    public func getString() -> String? {
        defer { getIndex += 1; }
        return getString(pos: getIndex)
    }
    
    public func getData() -> Data? {
        defer { getIndex += 1; }
        return getData(pos: getIndex)
    }
    
    private func bindOpt<T>(val: T?, onRegular: (T)->Void) {
        if let val = val {
            onRegular(val)
        } else {
            bindNull(pos: bindIndex)
            bindIndex += 1
        }
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
