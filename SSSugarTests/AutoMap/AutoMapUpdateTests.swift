/*
 
 Tests for AutoMap update(_:for:at:)
 
 [Done] key
    [Done] existing
    [fatalError] nonexistent
 [Done] index
    [Done] existing
    [fatalError] nonexitent
 [Done] same value
 [fatalError] empty AutoMap
 
 */

import XCTest
@testable import SSSugar

class AutoMapUpdateTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        let result = sut.update(Item.evensChangedValue, for: .evens, at: Item.evensChangedIndex)
        
        XCTAssertEqual(result, Item.evens.array[Item.evensChangedIndex])
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensChanged))
    }
    
    #warning("fatal error for nonexistent key")
//    func testNonexistentKey() {
//        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
//
//        XCTAssertNil(sut.update(Item.addValue, for: .new, at: 0))
//        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
//    }
    
    func testSameValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let value = Item.evens.array[Item.evensContaindeIndex]
        let result = sut.update(value, for: .evens, at: Item.evensContaindeIndex)
        
        XCTAssertEqual(result, value)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    #warning("fatal error for nonexistent key")
//    func testEmptyAutoMap() {
//        var sut = AutoMap<Item, [Int]>()
//
//        XCTAssertNil(sut.update(Item.addValue, for: .new, at: 0))
//        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
//    }
}
