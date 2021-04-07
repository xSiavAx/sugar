import Foundation

public struct DBTypedStatemnt<Stmt: SSDataBaseStatementProtocol, BArgs, GArgs>: SSDataBaseStatementProxing {
    public typealias OnBind = SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>.OnBind
    public typealias OnGet = SSDBTypedQueryHandlerCore<Stmt, BArgs, GArgs>.OnGet
    
    public var statement: SSDataBaseStatementProtocol { stmt }
    public let stmt: Stmt
    public var onBind: ((Stmt, BArgs) throws -> Void)!
    public var onGet: ((Stmt) throws -> GArgs)!
    
    public func bind(args: BArgs) throws {
        try onBind(stmt, args)
    }
    
    public func get() throws -> GArgs {
        return try onGet!(stmt)
    }
    
    public func allFor(args: BArgs?) throws -> [GArgs] {
        var result = [GArgs]()
        
        if let args = args {
            try bind(args: args)
        }
        
        while (try select()) {
            result.append(try get())
        }
        
        return result
    }
}
