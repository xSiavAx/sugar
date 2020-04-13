/*
 Tests for insert(e:) method in Array extension
 
 [Done] contained element
 [Done] not contained element
 [Done] empty array
 */
import XCTest
@testable import SSSugar

class ArrayInsertETests: XCTestCase {
    var sut = [0, 1, 2, 3, 4]
    
    func testContainedElement() {
        XCTAssert(sut.insert(e: 1))
        XCTAssertEqual(sut, [0, 1, 2, 3, 4, 1])
    }
    
    func testNotContainedElement() {
        XCTAssert(sut.insert(e: 10))
        XCTAssertEqual(sut, [0, 1, 2, 3, 4, 10])
    }
    
    func testEmptyArray() {
        sut = []
        XCTAssert(sut.insert(e: 10))
        XCTAssertEqual(sut, [10])
    }
}
