import Foundation

internal class SSUEChange: SSDmChange {
    internal var title: String { fatalError("Not omplemented") }
    
    internal init() {}
    
    internal required init(copy other: SSUEChange) {
        fatalError("Not omplemented")
    }
    
    internal func toUpdate() -> SSUpdate {
        fatalError("Not omplemented")
    }
}

internal class SSUERequest: SSDmRequest {
    internal var title: String { fatalError("Not omplemented") }
    
    internal init() {}
    
    internal required init(copy other: SSUERequest) {
        fatalError("Not omplemented")
    }
    
    internal func toUpdate() -> SSUpdate {
        fatalError("Not omplemented")
    }
}

typealias SSUEBatch = SSDmBatch<SSUERequest>
typealias SSUERevision = SSDmRevision<SSUEChange>
