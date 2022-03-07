import Foundation
import XCTest

public extension Error {
    func reflectingEqualTo(other: Error) -> Bool {
        return String(reflecting: self) == String(reflecting: other)
    }
}

public func XCTAssertReflectingError(_ error: Error?, expected: Error?) {
    XCTAssert(testCompare(loError: error, roError: expected), "Error \(String(describing: error)) doesn't match expected \(String(describing: expected))")
}

public func testCompare(loError: Error?, roError: Error?) -> Bool {
    switch (loError, roError) {
    case (.none, .none): return true
    case (.some(let lError), .some(let rError)): return lError.reflectingEqualTo(other: rError)
    default: return false
    }
}

