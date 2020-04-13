/*
 Tests for remove(e:) method in Array extension
 
 [Done] contained element
 [Done] not contained element
 [Done] first element
 [Done] last element
 [Done] one element
 [Done] empty array
 */

import XCTest
@testable import SSSugar

class ArrayRemoveETests: XCTestCase {
    var sut = [0, 1, 2, 3, 4]
    
    func testContainedElement() {
        XCTAssert(sut.remove(e: 3))
        XCTAssertEqual(sut, [0, 1, 2, 4])
    }
    
    func testNotContainedElement() {
        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, [0, 1, 2, 3, 4])
    }
    
    func testFirstElement() {
        XCTAssert(sut.remove(e: 0))
        XCTAssertEqual(sut, [1, 2, 3, 4])
    }
    
    func testLastElement() {
        XCTAssert(sut.remove(e: 4))
        XCTAssertEqual(sut, [0, 1, 2, 3])
    }
    
    func testOneElement() {
        sut = [10]
        
        XCTAssert(sut.remove(e: 10))
        XCTAssertEqual(sut, [])
    }
    
    func testEmptyArray() {
        sut = []
        
        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, [])
    }
}
