import Foundation

public protocol SSDBTypedQueryHandling {
    associatedtype Stmt: SSDataBaseStatementProtocol
    associatedtype BArgs
    associatedtype GArgs
    
    typealias Core = SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>
    typealias TypedStmt = DBTypedStatemnt<Stmt, BArgs, GArgs>
    typealias OnBind = Core.OnBind
    typealias OnGet = Core.OnGet

    var core: Core { get }
    
    func transform(stmt: SSDataBaseStatementProtocol) -> Stmt
}

public extension SSDBTypedQueryHandling {
    func statment(db: SSDataBaseProtocol) throws -> TypedStmt {
        let stmt = try db.statement(forQuery: core.query.raw)
        return TypedStmt(stmt: transform(stmt: stmt), onBind: core.onBind, onGet: core.onGet)
    }
    
    func withStmt<T>(db: SSDataBaseProtocol, exec: (TypedStmt) throws -> T ) throws -> T {
        let stmt = try statment(db: db)
        
        defer { try! stmt.release() }
        
        return try exec(stmt)
    }
    
    func commit(db: SSDataBaseProtocol, args: BArgs) throws {
        try commit(db: db, args: [args])
    }
    
    func commit(db: SSDataBaseProtocol, args: [BArgs]) throws {
        try withStmt(db: db) {(stmt) in
            try args.forEach {
                try stmt.bind(args: $0)
                try stmt.commit()
            }
        }
    }
    
    func select(db: SSDataBaseProtocol, args: BArgs) throws -> GArgs? {
        return try selectAll(db: db, args: args).first
    }

    func selectAll(db: SSDataBaseProtocol, args: BArgs? = nil) throws -> [GArgs] {
        return try withStmt(db: db) {(stmt) in
            try stmt.allFor(args: args)
        }
    }
    
    func selectAll(db: SSDataBaseProtocol, forEach args: [BArgs]) throws -> [(BArgs, [GArgs])] {
        return try withStmt(db: db) {(stmt) in
            try args.map { ($0, try stmt.allFor(args: $0)) }
        }
    }
    
    func selectUnion(db: SSDataBaseProtocol, forEach args: [BArgs]) throws -> [GArgs] {
        return try withStmt(db: db) {(stmt) in
            var result = [GArgs]()
            
            try args.forEach { result += try stmt.allFor(args: $0) }
            return result
        }
    }
}

public extension SSDBTypedQueryHandling where Stmt == SSDataBaseStatementProxy {
    func transform(stmt: SSDataBaseStatementProtocol) -> Stmt {
        return SSDataBaseStatementProxy(stmt)
    }
}

public extension SSDBTypedQueryHandling where Stmt == SSDataBaseStatementProcessor {
    func transform(stmt: SSDataBaseStatementProtocol) -> Stmt {
        return SSDataBaseStatementProcessor(stmt)
    }
}
