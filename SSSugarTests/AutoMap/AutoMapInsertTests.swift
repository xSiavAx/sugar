/*
 
 Tests for AutoMap insert(_:for:at)
 
 [Done] key
    [Done] contained
    [Done] not contained
 [Done] index
    [Done] contained
    [fatalError] not contained
 [Done] empty AutoMap
 
 */

import XCTest
@testable import SSSugar

class AutoMapInsertTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.insert(Item.oddsInsertedValue, for: .odds, at: Item.oddsInsertedIndex)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .oddsInserted))
    }
    
    func testNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.insert(Item.addValue, for: .new, at: 0)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds, .new))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        sut.insert(Item.addValue, for: .new, at: 0)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .new))
    }
}
