import Foundation

public typealias SSDBStoragingContainer = SSDBStoraging & SSDBStoragingTabled & SSDBStoragingInitialize & SSDBStoragingDeinitialize & SSDBStoragingTransacted

public protocol SSDBStoraging {
    var db: SSDataBaseStorage { get }
    
    func within<T, Transaction>(create: () throws -> Transaction,
                                cancel: (Transaction) throws -> Void,
                                commit: (Transaction) throws -> Void,
                                job: () throws -> T) throws -> T
}

public protocol SSDBStoragingTabled: SSDBStoraging {
    static var tables: [SSDBTable.Type] { get }
}

public protocol SSDBStoragingInitialize: SSDBStoragingTabled {
    func initializeStructure() throws
    func initializeStructure(strictExist: Bool) throws
}

public extension SSDBStoragingInitialize {
    func initializeStructure() throws {
        try initializeStructure(strictExist: true)
    }

    func initializeStructure(strictExist: Bool) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.createQueries(strictExist: strictExist) }

        try db.exec(queries: queries)
    }
}

public protocol SSDBStoragingDeinitialize: SSDBStoragingTabled {
    func deinitializeStructure() throws
    func deinitializeStructure(strictExist: Bool) throws
}

public extension SSDBStoragingDeinitialize {
    func deinitializeStructure() throws {
        try deinitializeStructure(strictExist: true)
    }

    func deinitializeStructure(strictExist: Bool) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.dropQueries(strictExist: strictExist) }

        try db.exec(queries: queries)
    }
}

public protocol SSDBStoragingTransacted: SSDBStoraging {
    func withinTransaction<T>(job: () throws -> T ) throws -> T
    func withinSavePoint<T>(_ label: String, job: () throws -> T) throws -> T
}

public extension SSDBStoragingTransacted {
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

    private func within<T, Transaction>(create: () throws -> Transaction,
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
