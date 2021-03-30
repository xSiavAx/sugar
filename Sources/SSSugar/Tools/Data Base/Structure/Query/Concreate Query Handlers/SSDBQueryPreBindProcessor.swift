import Foundation

public struct SSDBQueryPreBindProcessor<PBArgs, BArgs, GArgs> {
    public typealias OnPreBind = (Base.Stmt, PBArgs) throws -> Void
    public typealias Base = SSDBQueryProcessor<BArgs, GArgs>
    
    public let base: Base
    public let preBind: OnPreBind
    
    public init(_ query: String,
                onPreBind: @escaping OnPreBind,
                onBind: Base.OnBind? = nil,
                onGet: Base.OnGet? = nil) {
        base = Base(query, onBind: onBind, onGet: onGet)
        preBind = onPreBind
    }
    
    func commit(db: SSDataBaseProtocol, preArgs: PBArgs, args: [BArgs]) throws {
        let onPreBind: Base.PreBind = { try preBind($0.stmt, preArgs) }
        try base.commit(db: db, args: args, preBind: onPreBind)
    }
}

