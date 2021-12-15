import Foundation

public func json(_ lhs: [String : Any]?, eqaulTo rhs: [String : Any]?) -> Bool {
    guard let first = lhs else { return rhs == nil }
    guard let second = rhs else { return false }

    return NSDictionary(dictionary: first).isEqual(to: second)
}

