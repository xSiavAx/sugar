/*
 Tests for AutoMap.Iterator next()
 
 [Done] regular container
 [Done] empty container
 [Done] mixed container
 [Done] empty map
 */

import XCTest
@testable import SSSugarCore

class AutoMapIteratorNextTests: XCTestCase {
    typealias DefaultAutoMap = AutoMap<Item, [Int]>
    typealias Iterator = DefaultAutoMap.Iterator
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testRegularContainer() {
        let sut = Iterator(map: testHelper.arrayMap(from: .evens, .odds))
        let expectedElements = testHelper.iteratorArrayElements(from: .evens, .odds)
        
        testHelper.assertIterateOverElements(sut, with: expectedElements)
    }

    func testEmptyContainer() {
        let sut = Iterator(map: testHelper.arrayMap(from: .empty))
        
        XCTAssertNil(sut.next())
    }
    
    func testMixedContainer() {
        let sut = Iterator(map: testHelper.arrayMap(from: .empty, .odds))
        let expectedElements = testHelper.iteratorArrayElements(from: .odds)
        
        testHelper.assertIterateOverElements(sut, with: expectedElements)
    }
    
    func testEmptyMap() {
        let sut = DefaultAutoMap.Iterator(map: [:])
        
        XCTAssertNil(sut.next())
    }
}
