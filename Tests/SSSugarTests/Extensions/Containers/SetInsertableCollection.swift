/*
 Tests for insert(e:), remove(e:) in Set extension with InsertableCollection conformance

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
@testable import SSSugarCore

class SetInsertableCollection: XCTestCase {
    static let defaultArray = [0, 1, 2, 3, 4]
    
    var sut = Set(SetInsertableCollection.defaultArray)

    func testInsertContainedElement() {
        XCTAssertFalse(sut.insert(e: 3))
        XCTAssertEqual(sut, Set(Self.defaultArray))
    }

    func testInsertNotContainedElement() {
        XCTAssert(sut.insert(e: 10))
        XCTAssertEqual(sut, Set(Self.defaultArray + [10]))
    }

    func testInsertEmptySet() {
        sut = Set<Int>()

        XCTAssert(sut.insert(e: 10))
        XCTAssertEqual(sut, Set(arrayLiteral: 10))
    }

    func testRemoveContainedElement() {
        XCTAssert(sut.remove(e: 3))
        XCTAssertEqual(sut, Set(arrayLiteral: 0, 1, 2, 4))
    }

    func testRemoveNotContainedElement() {
        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, Set(Self.defaultArray))
    }

    func testRemoveOneElement() {
        sut = Set(arrayLiteral: 10)

        XCTAssert(sut.remove(e: 10))
        XCTAssertEqual(sut, Set<Int>())
    }

    func testRemoveEmptySet() {
        sut = Set<Int>()

        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, Set<Int>())
    }
}
