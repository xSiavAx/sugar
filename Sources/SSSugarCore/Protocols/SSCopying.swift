import Foundation

#warning("Remove me")
// It's unsafe to use copy on objects and causes a lot of problems. If u need copyable use Value Types.

public protocol SSCopying: AnyObject {
    init(copy other: Self)
    func copy() -> Self
}

extension SSCopying {
    public func copy() -> Self {
        return type(of: self).init(copy: self)
    }
}
