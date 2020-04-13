/*
 Tests for removeAll() method in AutoMap
 
 [Done] regular
 [Done] empty AutoMap
 */

import XCTest
@testable import SSSugar

class AutoMapRemoveAllTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testRegular() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds, .fibonacci))
        
        XCTAssertTrue(sut.removeAll())
        testHelper.assertEqual(sut, [:])
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertFalse(sut.removeAll())
        testHelper.assertEqual(sut, [:])
    }
}
