import Foundation

public protocol SSDBStoraging {
    var db: SSDataBaseStorage { get }
    
    static var tables: [SSDBTable.Type] {get}
}

public extension SSDBStoraging {
    func initializeStructure(strictExist: Bool = true) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.createQueries(strictExist: strictExist) }
        
        try db.exec(queries: queries)
    }
    
    func deinitializeStructure(strictExist: Bool = true) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.dropQueries(strictExist: strictExist) }
        
        try db.exec(queries: queries)
    }
    
    func withinTransaction<T>(job: () throws -> T ) throws -> T {
        try within(create: { try db.beginTransaction() },
                   cancel: { try db.cancelTransaction() },
                   commit: { try db.commitTransaction() },
                   job: job)
    }
    
    func withinSavePoint<T>(_ label: String, job: () throws -> T) throws -> T {
        try within(create: { try db.savePoint(withTitle: label) },
                   cancel: { try $0.rollBack(); try $0.release() },
                   commit: { try $0.release() },
                   job: job)
    }
    
    func within<T, Transaction>(create: () throws -> Transaction,
                                cancel: (Transaction) throws -> Void,
                                commit: (Transaction) throws -> Void,
                                job: () throws -> T) throws -> T {
        let transaction = try create()
        var result: T
        
        do {
            result = try job()
        } catch {
            try cancel(transaction)
            throw error
        }
        try commit(transaction)
        return result
    }
}
