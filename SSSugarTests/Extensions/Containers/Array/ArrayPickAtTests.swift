/*
 Tests for pick(at:) Array extension
 
 [Done] regular
 [Done] first element
 [Done] last element
 [Done] single element array
 [fatalError] incorrect index
 */

import XCTest
@testable import SSSugar

class ArrayPickAtTests: XCTestCase {
    var sut = [0, 1, 2, 3, 4]

    override func tearDown() {
        sut = []
    }

    func testRegular() {
        XCTAssertEqual(sut.pick(at: 2), 2)
        XCTAssertEqual(sut, [0, 1, 3, 4])
    }
    
    func testFirstElement() {
        XCTAssertEqual(sut.pick(at: 0), 0)
        XCTAssertEqual(sut, [1, 2, 3, 4])
    }
    
    func testLastElement() {
        XCTAssertEqual(sut.pick(at: 4), 4)
        XCTAssertEqual(sut, [0, 1, 2, 3])
    }
    
    func testSingleElementArray() {
        sut = [3]
        XCTAssertEqual(sut.pick(at: 0), 3)
        XCTAssertEqual(sut, [])
    }
}
