import Foundation

public protocol SSDataBaseStatementProtocol {
    func bind(int : Int, pos : Int)
    func bind(int64 : Int64, pos : Int)
    func bind(double : Double, pos : Int)
    func bind(string : String, pos : Int)
    func bind(data : Data, pos : Int)
    
    func getInt(pos : Int) -> Int
    func getInt64(pos : Int) -> Int64
    func getDouble(pos : Int) -> Double
    func getString(pos : Int) -> String?
    func getData(pos : Int) -> Data
    
    func select() -> Bool
    func commit() throws
    func clear()
    func release()
}

public protocol SSDataBaseSavePointProtocol {
    func rollBack()
    func release()
}

public protocol SSTransacted {
    var isTransactionStarted : Bool {get}
    
    func beginTransaction()
    func commitTransaction()
    func cancelTransaction()
}

public protocol SSDataBaseStatementCreator {
    func statement(forQuery : String) -> SSDataBaseStatementProtocol
}

public protocol SSDataBaseProtocol: SSTransacted, SSDataBaseStatementCreator {
    func createSavePoint(withTitle: String) -> SSDataBaseSavePointProtocol
}
