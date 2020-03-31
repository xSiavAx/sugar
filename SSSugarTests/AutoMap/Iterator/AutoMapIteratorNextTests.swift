/*
 
 Tests for AutoMap.Iterator next()
 
 [Done] container
    [infiniteLoop] regular
    [infiniteLoop] empty
    [infiniteLoop] mixed
 [Done] empty map
 
 */

import XCTest
@testable import SSSugar

//TODO: [Review] Cases look very similar to MakeIterator ones

class AutoMapIteratorNextTests: XCTestCase {
    typealias DefaultAutoMap = AutoMap<Item, [Int]>
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testRegularContainer() {
        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .evens, .odds))
        let expectedElements = testHelper.iteratorArrayElements(from: .evens, .odds)

        testHelper.assertIterateOverElements(sut, with: expectedElements)
    }

    func testEmptyContainer() {
        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .empty))

        XCTAssertNil(sut.next())
    }
    
    func testMixedContainer() {
        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .empty, .odds))
        let expectedElements = testHelper.iteratorArrayElements(from: .odds)

        testHelper.assertIterateOverElements(sut, with: expectedElements)
    }
    
    func testEmptyMap() {
        let sut = DefaultAutoMap.Iterator(map: [:])
        
        XCTAssertNil(sut.next())
    }
}
