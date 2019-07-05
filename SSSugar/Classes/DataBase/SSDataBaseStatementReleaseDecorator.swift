import Foundation

class SSDataBaseStatementReleaseDecorator: SSReleaseDecorator {
    var statement : SSDataBaseStatementProtocol { return decorated as! SSDataBaseStatementProtocol }
    
    init(statement: SSDataBaseStatementProtocol, onCreate: @escaping (SSDataBaseStatementProtocol) -> Void, onRelease mOnRelease: @escaping (SSDataBaseStatementProtocol) -> Void) {
        super.init(decorated: statement, onCreate: onCreate as! (SSReleasable) -> Void, onRelease: mOnRelease as! (SSReleasable) -> Void)
    }
}

extension SSDataBaseStatementReleaseDecorator: SSDataBaseStatementProtocol {
    func bind(int: Int, pos: Int) {
        statement.bind(int:int, pos:pos)
    }
    
    func bind(int64: Int64, pos: Int) {
        statement.bind(int64:int64, pos:pos)
    }
    
    func bind(double: Double, pos: Int) {
        statement.bind(double:double, pos:pos)
    }
    
    func bind(string: String, pos: Int) {
        statement.bind(string:string, pos:pos)
    }
    
    func bind(data: Data, pos: Int) {
        statement.bind(data:data, pos:pos)
    }
    
    func getInt(pos: Int) -> Int {
        return statement.getInt(pos:pos)
    }
    
    func getInt64(pos: Int) -> Int64 {
        return statement.getInt64(pos:pos)
    }
    
    func getDouble(pos: Int) -> Double {
        return statement.getDouble(pos:pos)
    }
    
    func getString(pos: Int) -> String? {
        return statement.getString(pos:pos)
    }
    
    func getData(pos: Int) -> Data {
        return statement.getData(pos:pos)
    }
    
    func select() -> Bool {
        return statement.select()
    }
    
    func commit() throws {
        try statement.commit()
    }
    
    func clear() {
        statement.clear()
    }
}
