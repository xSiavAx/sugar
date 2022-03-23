import Foundation

/// - Warning: **Deprecated**. Use `nsCompare(_ lhs: _ rhs:)` instead.
@available(*, deprecated, message: "Use `nsCompare(_ lhs: _ rhs:)` instead")
public func json(_ lhs: [String : Any]?, eqaulTo rhs: [String : Any]?) -> Bool {
    return nsCompare(lhs, eqaulTo: rhs)
}

public func nsCompare(_ lhs: [AnyHashable : Any]?, eqaulTo rhs: [AnyHashable : Any]?) -> Bool {
    guard let first = lhs else { return rhs == nil }
    guard let second = rhs else { return false }

    return NSDictionary(dictionary: first).isEqual(to: second)
}
