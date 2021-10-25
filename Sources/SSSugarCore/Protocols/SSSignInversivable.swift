import Foundation

protocol SSSignInversivable {
    static prefix func - (val: Self) -> Self
}

extension AdditiveArithmetic where Self: SSSignInversivable {
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs + (-rhs)
    }
}
