import Foundation

public struct SSDBTypedQueryHandlerCore<Stmt: SSDataBaseStatementProtocol, BArgs, GArgs> {
    public typealias OnBind = (Stmt, BArgs) throws -> Void
    public typealias OnGet = ((Stmt) throws -> GArgs)
    public typealias Query = SSDBTypedQuery<BArgs, GArgs>
    
    public let query: Query
    public var onBind: OnBind?
    public var onGet: OnGet?
}
