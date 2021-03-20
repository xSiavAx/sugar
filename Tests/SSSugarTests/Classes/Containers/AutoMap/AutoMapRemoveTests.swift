/*
 Tests for remove(_:for:) method in AutoMap
 
 [Done] contained key contained value
 [Done] contained key not contained value
 [Done] not contained key contained value
 [Done] not contained key not contained value
 [Done] empty AutoMap
 */

import XCTest
@testable import SSSugar

class AutoMapRemoveTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testContainedKeyContainedValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertTrue(sut.remove(Item.evensWithoutValueValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutValue, .odds))
    }
    
    func testContainedKeyNotContainedValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.remove(Item.oddsFirstValue, for: .evens))
        testHelper.assertEqual(sut, map)
    }
    
    func testNotContainedKeyContainedValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.remove(Item.evensSecondValue, for: .fibonacci))
        testHelper.assertEqual(sut, map)
    }
    
    func testNotContainedKeyNotContainedValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.remove(Item.oddsFirstValue, for: .fibonacci))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        sut.add(container: [], for: .evens)
        
        XCTAssertFalse(sut.remove(Item.evensSecondValue, for: .evens))
        testHelper.assertEqual(sut, [:])
    }
}
