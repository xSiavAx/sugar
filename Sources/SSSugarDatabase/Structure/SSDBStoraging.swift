import Foundation

public typealias SSDBStoraging = SSBaseDBStoraging & SSDBTabledStoraging & SSDBInitializableStoraging & SSDBDeinitializableStoraging & SSTransactedStoraging

public protocol SSBaseDBStoraging {
    var db: SSDataBaseProtocol { get }
}

// MARK: - SSDBStoragingTabled

public protocol SSDBTabledStoraging: SSBaseDBStoraging {
    static var tables: [SSDBTable.Type] { get }
}

// MARK: - SSDBInitializableStoraging

public protocol SSDBInitializableStoraging {
    func initializeStructure() throws
    func initializeStructure(strictExist: Bool) throws
}

// MARK: Self: SSDBStoragingTabled

public extension SSDBInitializableStoraging where Self: SSDBTabledStoraging {
    func initializeStructure() throws {
        try initializeStructure(strictExist: true)
    }

    func initializeStructure(strictExist: Bool) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.createQueries(strictExist: strictExist) }

        try db.transacted(queries: queries)
    }
}

// MARK: - SSDBDeinitializableStoraging

public protocol SSDBDeinitializableStoraging {
    func deinitializeStructure() throws
    func deinitializeStructure(strictExist: Bool) throws
}

// MARK: Self: SSDBStoragingTabled

public extension SSDBDeinitializableStoraging where Self: SSDBTabledStoraging {
    func deinitializeStructure() throws {
        try deinitializeStructure(strictExist: true)
    }

    func deinitializeStructure(strictExist: Bool) throws {
        let queries = Self.tables.reduce([]) { $0 + $1.dropQueries(strictExist: strictExist) }

        try db.transacted(queries: queries)
    }
}

// MARK: - SSDBStoragingTransacted

public protocol SSTransactedStoraging {
    func withinTransaction<T>(job: () throws -> T ) throws -> T
    func withinSavePoint<T>(_ label: String, job: () throws -> T) throws -> T
}

// MARK: Self: SSBaseDBStoraging

public extension SSTransactedStoraging where Self: SSBaseDBStoraging {
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
