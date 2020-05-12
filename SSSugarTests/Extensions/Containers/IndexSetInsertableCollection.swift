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
    //TODO: [Review] Why din't use IndexSet?
    // static let defaultSet = IndexSet(integersIn: 0..<5)
    static let defaultArray = [0, 1, 2, 3, 4]
    
    //TODO: [Review] Just `defaultArray`
    var sut = IndexSet(IndexSetInsertableCollection.defaultArray)

    //TODO: [Review] Its better to define `expectedResult` instead of inline calculation
    func testInsertContainedElement() {
        XCTAssert(sut.insert(e: 3))
        XCTAssertEqual(sut, IndexSet(Self.defaultArray))
    }

    func testInsertNotContainedElement() {
        XCTAssert(sut.insert(e: 10))
        XCTAssertEqual(sut, IndexSet(Self.defaultArray + [10]))
    }

    func testInsertEmptyIndexSet() {
        sut = IndexSet()

        XCTAssert(sut.insert(e: 10))
        //TODO: [Review] IndexSet(integer: 10)
        XCTAssertEqual(sut, IndexSet(arrayLiteral: 10))
    }

    func testRemoveContainedElement() {
        XCTAssert(sut.remove(e: 3))
        //TODO: [Review] Index set with range
        XCTAssertEqual(sut, IndexSet(arrayLiteral: 0, 1, 2, 4))
    }

    func testRemoveNotContainedElement() {
        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, IndexSet(Self.defaultArray))
    }

    func testRemoveOneElement() {
        sut = IndexSet(arrayLiteral: 10)

        XCTAssert(sut.remove(e: 10))
        XCTAssertEqual(sut, IndexSet())
    }

    func testRemoveEmptySet() {
        sut = IndexSet()

        XCTAssertFalse(sut.remove(e: 10))
        XCTAssertEqual(sut, IndexSet())
    }
}
