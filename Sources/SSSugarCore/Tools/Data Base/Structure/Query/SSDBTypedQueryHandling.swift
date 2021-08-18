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
    typealias PreBind = (TypedStmt) throws -> Void
    
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
    
    func commit(db: SSDataBaseProtocol, args: [BArgs], preBind: PreBind? = nil) throws {
        try commit(db: db, args: args, preBind: preBind) { try $0.bind(args: $1) }
    }
    
    func select(db: SSDataBaseProtocol, args: BArgs) throws -> GArgs? {
        return selectAll(db: db, optArgs: args).first
    }

    func selectAll(db: SSDataBaseProtocol, args: BArgs) throws -> [GArgs] {
        return try selectAll(db: db, optArgs: args)
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
    
    private func selectAll(db: SSDataBaseProtocol, optArgs: BArgs? = nil) throws -> [GArgs] {
        return try withStmt(db: db) {(stmt) in
            try stmt.allFor(args: args)
        }
    }
    
    private func commit(db: SSDataBaseProtocol, args: [BArgs], preBind: PreBind? = nil, bind: ((TypedStmt, BArgs) throws -> Void)?) throws {
        try withStmt(db: db) {(stmt) in
            try preBind?(stmt)
            try args.forEach {
                try bind?(stmt, $0)
                try stmt.commit()
            }
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

public extension SSDBTypedQueryHandling where BArgs == Void {
    func commit(db: SSDataBaseProtocol, preBind: PreBind? = nil) throws {
        try commit(db: db, args: [()], preBind: preBind, bind: nil)
    }
    
    func select(db: SSDataBaseProtocol) throws -> GArgs? {
        return selectAll(db: db, optArgs: nil).first
    }

    func selectAll(db: SSDataBaseProtocol) throws -> [GArgs] {
        return try selectAll(db: db, optArgs: nil)
    }
}
