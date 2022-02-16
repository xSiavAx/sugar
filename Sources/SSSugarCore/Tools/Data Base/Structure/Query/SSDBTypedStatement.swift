import Foundation

public struct DBTypedStatemnt<Stmt: SSDataBaseStatementProtocol, BArgs, GArgs>: SSDataBaseStatementProxing {
    public typealias OnBind = SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>.OnBind
    public typealias OnGet = SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>.OnGet
    
    public var statement: SSDataBaseStatementProtocol { stmt }
    public let stmt: Stmt
    public var onBind: ((Stmt, BArgs) throws -> Void)!
    public var onGet: ((Stmt) throws -> GArgs)!
    
    public init(stmt: Stmt, onBind: ((Stmt, BArgs) throws -> Void)? = nil, onGet: ((Stmt) throws -> GArgs)? = nil) {
        self.stmt = stmt
        self.onBind = onBind
        self.onGet = onGet
    }
    
    public func bind(args: BArgs) throws {
        try onBind(stmt, args)
    }
    
    public func get() throws -> GArgs {
        return try onGet!(stmt)
    }
    
    public func allFor(args: BArgs?) throws -> [GArgs] {
        var result = [GArgs]()
        
        try bindIfNeeded(args: args)
        
        while (try select()) {
            result.append(try get())
        }
        
        return result
    }
    
    public func firstFor(args: BArgs?) throws -> GArgs? {
        try bindIfNeeded(args: args)
        return try select() ? try get() as GArgs : nil
    }
    
    private func bindIfNeeded(args: BArgs?) throws {
        guard let args = args else { return }
        try bind(args: args)
    }
}
