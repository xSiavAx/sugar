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

public protocol SSDmChange: SSDataModifying {
    static var title: String {get}
}

public protocol SSDmRequest: SSDataModifying {
    static var title: String {get}
}
