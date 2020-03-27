/*
 
 Tests for AutoMap update(_:for:at:)
 
 [Done] key
    [Done] contained
    [fatalError] not contained
 [Done] index
    [Done] contained
    [fatalError] not contained
 [Done] same value
 [fatalError] empty AutoMap
 
 */

import XCTest
@testable import SSSugar

class AutoMapUpdateTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        let result = sut.update(Item.evensChangedValue, for: .evens, at: Item.evensChangedIndex)
        
        XCTAssertEqual(result, Item.evens.array[Item.evensChangedIndex])
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensChanged))
    }
    
    #warning("fatal error for not contained key")
//    func testNotContainedKey() {
//        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
//
//        XCTAssertNil(sut.update(Item.addValue, for: .new, at: 0))
//        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
//    }
    
    func testSameValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let value = Item.evens.array[Item.evensContainedIndex]
        let result = sut.update(value, for: .evens, at: Item.evensContainedIndex)
        
        XCTAssertEqual(result, value)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    #warning("fatal error for not contained key")
//    func testEmptyAutoMap() {
//        var sut = AutoMap<Item, [Int]>()
//
//        XCTAssertNil(sut.update(Item.addValue, for: .new, at: 0))
//        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
//    }
}
