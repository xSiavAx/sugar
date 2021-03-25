import Foundation

public struct SSDBQueryProcessor<BArgs, GArgs>: SSDBTypedQueryHandling {
    public typealias Stmt = SSDataBaseStatementProcessor
    
    public let core: SSDBTypedQueryHandlerCore<SSDataBaseStatementProcessor, BArgs, GArgs> //Idk why `let core: Core` doesnt compiles here
    
    public init(_ query: String, onBind: OnBind? = nil, onGet: OnGet? = nil) {
        core = Core(query: Core.Query(raw: query), onBind: onBind, onGet: onGet)
    }
}
