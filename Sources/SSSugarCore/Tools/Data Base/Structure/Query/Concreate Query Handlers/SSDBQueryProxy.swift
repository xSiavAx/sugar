import Foundation

public struct SSDBQueryProxy<BArgs, GArgs>: SSDBTypedQueryHandling {
    public typealias Stmt = SSDataBaseStatementProxy
    
    public let core: SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>
    
    public init(_ query: String, onBind: OnBind? = nil, onGet: OnGet? = nil) {
        core = Core(query: Core.Query(raw: query), onBind: onBind, onGet: onGet)
    }
}

public struct SSDBQueryPreBinder<PBArgs, BArgs, GArgs>: SSDBTypedQueryHandling {
    public typealias Stmt = SSDataBaseStatementProxy
    public typealias OnPreBind = (Stmt, PBArgs) throws -> Void
    
    public let core: SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>
    public let preBind: OnPreBind
    
    public init(_ query: String, onPreBind: @escaping OnPreBind, onBind: OnBind? = nil, onGet: OnGet? = nil) {
        core = Core(query: Core.Query(raw: query), onBind: onBind, onGet: onGet)
        preBind = onPreBind
    }
    
    public func commit(db: SSDataBaseProtocol, preArgs: PBArgs, args: [BArgs]) throws {
        try commit(db: db, args: args) { try preBind($0.stmt, preArgs) }
    }
}
