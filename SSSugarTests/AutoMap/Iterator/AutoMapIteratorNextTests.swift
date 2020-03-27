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

class AutoMapIteratorNextTests: XCTestCase {
    typealias DefaultAutoMap = AutoMap<Item, [Int]>
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    #warning("infinite loop")
//    func testRegularContainer() {
//        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .evens, .odds))
//        let expectedElements = testHelper.iteratorArrayElements(from: .evens, .odds)
//
//        testHelper.assertIterateOverElements(sut, with: expectedElements)
//    }
    
    #warning("infinite loop")
//    func testEmptyContainer() {
//        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .empty))
//
//        XCTAssertNil(sut.next())
//    }
    
    #warning("infinite loop")
//    func testMixedContainer() {
//        let sut = DefaultAutoMap.Iterator(map: testHelper.arrayMap(from: .empty, .odds))
//        let expectedElements = testHelper.iteratorArrayElements(from: .odds)
//
//        testHelper.assertIterateOverElements(sut, with: expectedElements)
//    }
    
    func testEmptyMap() {
        let sut = DefaultAutoMap.Iterator(map: [:])
        
        XCTAssertNil(sut.next())
    }
}
