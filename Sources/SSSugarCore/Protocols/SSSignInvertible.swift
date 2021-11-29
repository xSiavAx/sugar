import Foundation

protocol SSSignInvertible {
    static prefix func - (val: Self) -> Self
}

extension AdditiveArithmetic where Self: SSSignInvertible {
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs + (-rhs)
    }
}
