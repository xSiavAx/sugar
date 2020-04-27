import Foundation

internal class SSUEModify: SSDataModifying {
    internal var core: SSDataModifyCore { fatalError("Not implemented") }
    internal var title: String { fatalError("Not implemented") }
    
    internal init() {}
    
    internal required init(copy other: SSUEModify) {
        fatalError("Not inmplemented")
    }
}

internal class SSUECoredModify<Core: SSDataModifyCore&SSCopying>: SSUEModify {
    internal let iCore: Core
    internal override var core: SSDataModifyCore { get{iCore} }
    
    internal init(core: Core) {
        iCore = core
        super.init()
    }
    
    internal required init(copy other: SSUEModify) {
        let mOther = other as! Self
        iCore = mOther.iCore.copy()
        super.init()
    }
}

internal class SSUEChange<Core: SSDataModifyCore&SSCopying>: SSUECoredModify<Core> {}

internal class SSUERequest<Core: SSDataModifyCore&SSCopying>: SSUECoredModify<Core> {}

typealias SSUERevision = SSDmRevision<SSUEModify>
typealias SSUEBatch = SSDmBatch<SSUEModify>
