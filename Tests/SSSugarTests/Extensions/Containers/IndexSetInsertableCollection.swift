/*
 Tests for insert(e:), remove(e:) in IndexSet extension with InsertableCollection conformance

 [insert] insert(e:)
 [remove] remove(e:)

 [Done] insert contained element
 [Done] insert not contained element
 [Done] insert empty set
 [Done] remove contained element
 [Done] remove not contained element
 [Done] remove one element
 [Done] remove empty set
 */

import XCTest
@testable import SSSugar

class IndexSetInsertableCollection: XCTestCase {
	var sut = IndexSet(integersIn: 0..<3)

    func testInsertContainedElement() {
		XCTAssert(sut.insert(e: 1))
		XCTAssertEqual(sut, IndexSet(integersIn: 0..<3))
    }

    func testInsertNotContainedElement() {
        XCTAssert(sut.insert(e: 10))
		XCTAssertEqual(sut, IndexSet(arrayLiteral: 0, 1, 2, 10))
    }

    func testInsertEmptyIndexSet() {
        sut = IndexSet()

        XCTAssert(sut.insert(e: 10))
		XCTAssertEqual(sut, IndexSet(integer: 10))
    }

    func testRemoveContainedElement() {
		XCTAssert(sut.remove(e: 1))
		XCTAssertEqual(sut, IndexSet(arrayLiteral: 0, 2))
    }

    func testRemoveNotContainedElement() {
        XCTAssertFalse(sut.remove(e: 10))
		XCTAssertEqual(sut, IndexSet(integersIn: 0..<3))
    }

    func testRemoveOneElement() {
		sut = IndexSet(integer: 10)

        XCTAssert(sut.remove(e: 10))
        XCTAssertEqual(sut, IndexSet())
    }

    func testRemoveEmptySet() {
        sut = IndexSet()

        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, IndexSet())
    }
}
