/*
 
 Tests for AutoMap makeIterator()
 
 [Done] container
    [infiniteLoop] regular
    [Done] empty
    [infiniteLoop] mixed
 [Done] empty map
 
 */

import XCTest
@testable import SSSugar

class AutoMapMakeIteratorTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    #warning("infinite loop")
//    func testRegularContainer() {
//        let sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
//        let expectedElements = testHelper.iteratorArrayElements(from: .evens, .odds)
//
//        testHelper.assertIterateOverElements(sut.makeIterator(), with: expectedElements)
//    }
    
    func testEmptyContainer() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .empty))
        
        XCTAssertNil(sut.makeIterator().next())
    }
    
    #warning("infinite loop")
//    func testMixedContainer() {
//        let sut = AutoMap(map: testHelper.arrayMap(from: .empty, .odds))
//        let expectedElements = testHelper.iteratorArrayElements(from: .odds)
//        
//        testHelper.assertIterateOverElements(sut.makeIterator(), with: expectedElements)
//    }
    
    func testEmptyMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.makeIterator().next())
    }
}
