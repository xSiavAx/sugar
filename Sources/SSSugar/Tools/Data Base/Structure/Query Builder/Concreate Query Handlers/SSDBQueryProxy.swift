import Foundation

public struct SSDBQueryProxy<BArgs, GArgs>: SSDBTypedQueryHandling {
    public typealias Stmt = SSDataBaseStatementProxy
    
    public let core: Core
    
    public init(_ query: String, onBind: OnBind? = nil, onGet: OnGet? = nil) {
        core = Core(query: Core.Query(raw: query), onBind: onBind, onGet: onGet)
    }
}
