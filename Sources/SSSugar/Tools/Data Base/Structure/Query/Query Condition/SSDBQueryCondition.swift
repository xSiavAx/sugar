import Foundation

public protocol SSDBQueryCondition {
    func toString() -> String
}

extension String: SSDBQueryCondition {
    public func toString() -> String {
        return self
    }
}
