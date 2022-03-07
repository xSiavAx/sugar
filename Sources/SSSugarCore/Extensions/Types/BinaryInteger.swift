import Foundation

extension BinaryInteger {
    var isEven: Bool { self % 2 == 0 }
    var isOdd: Bool { self % 2 != 0 }
}
