import Foundation

public protocol SSDataModifying: SSCopying {
    func toUpdate() -> SSUpdate
}

public protocol SSDmChange: SSDataModifying {
    var title: String {get}
}

public protocol SSDmRequest: SSDataModifying {
    var title: String {get}
}

public protocol SSDmFinalChange: SSDataModifying {
    static var title: String {get}
}

public protocol SSDmFinalRequest: SSDataModifying {
    static var title: String {get}
}

extension SSDmFinalChange {
    var title: String { Self.title }
}

extension SSDmFinalRequest {
    var title: String { Self.title }
}
