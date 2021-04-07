/*
 Tests for makeIterator() method in AutoMap

 [Done] regular container
 [Done] empty container
 [Done] mixed container
 [Done] empty map
 */

import XCTest
@testable import SSSugarCore

class AutoMapMakeIteratorTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testRegularContainer() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertNotNil(sut.makeIterator())
    }
    
    func testEmptyContainer() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .empty))
        
        XCTAssertNotNil(sut.makeIterator())
    }
    
    func testMixedContainer() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .empty, .odds))
        
        XCTAssertNotNil(sut.makeIterator())
    }
    
    func testEmptyMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNotNil(sut.makeIterator())
    }
}
