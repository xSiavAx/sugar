import Foundation

public protocol SSDataModifyCore {
    func toUpdate() -> SSUpdate
}

public protocol SSDataModifying: SSCopying {
    var core: SSDataModifyCore {get}
    var title: String {get}
}

extension SSDataModifying {
    func toUpdate() -> SSUpdate {
        core.toUpdate()
    }
}

//TODO: Rename SSDmChange and SSDmRequest to SSDmFinalChange and SSDmFinalRequest
//TODO: Make SSDmChange and SSDmRequest not conforming to SSDataModifying. It allows use em in composites to specify SSDataModifying is Change or Request. Move static 'title' to these protocols (from 'final' ones).
//TODO: Make SSDmFinalChange and SSDmFinalRequest as composites of SSDmChange and SSDmRequest with SSDataModifying

public protocol SSDmChange: SSDataModifying {
    static var title: String {get}
}

public protocol SSDmRequest: SSDataModifying {
    static var title: String {get}
}
