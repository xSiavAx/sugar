import Foundation

public protocol SSCopying: AnyObject {
    init(copy other: Self)
    func copy() -> Self
}

extension SSCopying {
    public func copy() -> Self {
        return type(of: self).init(copy: self)
    }
}
