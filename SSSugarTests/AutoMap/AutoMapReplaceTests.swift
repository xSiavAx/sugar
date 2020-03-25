/*

 Tests for AutoMap replace(_:for:)
 
 [Done] key
    [Done] existing
    [Done] nonexistent
 [Done] empty AutoMap
 [fatalError] empty container

*/

import XCTest
@testable import SSSugar

class AutoMapReplaceTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.replace(Item.evensNew.array, for: .evens), Item.evens.array)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensNew, .odds))
    }
    
    func testNonexistentKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertNil(sut.replace(Item.odds.array, for: .odds))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.replace(Item.evens.array, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens))
    }
}
