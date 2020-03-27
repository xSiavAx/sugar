/*

 Tests for AutoMap replace(_:for:)
 
 [Done] key
    [Done] contained
    [Done] not contained
 [Done] same value
 [Done] empty AutoMap
 [fatalError] empty container

*/

import XCTest
@testable import SSSugar

class AutoMapReplaceTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.replace(Item.evensNew.array, for: .evens), Item.evens.array)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensNew, .odds))
    }
    
    func testNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertNil(sut.replace(Item.odds.array, for: .odds))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testSameValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.replace(Item.evens.array, for: .evens), Item.evens.array)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.replace(Item.evens.array, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens))
    }
}
