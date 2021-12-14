import Foundation
import XCTest

public extension Error {
    func reflectingEqualTo(other: Error) -> Bool {
        return String(reflecting: self) == String(reflecting: other)
    }
}

public func XCTAssertReflectingError(_ error: Error?, expected: Error?) {
    if let expected = expected {
        if let error = error {
            XCTAssert(expected.reflectingEqualTo(other: error))
        } else {
            XCTFail()
        }
    } else {
        XCTAssertNil(error)
    }
}
