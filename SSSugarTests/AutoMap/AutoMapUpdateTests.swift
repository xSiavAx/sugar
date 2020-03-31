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
    
    func testSameValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let value = Item.evens.array[Item.evensContainedIndex]
        let result = sut.update(value, for: .evens, at: Item.evensContainedIndex)
        
        XCTAssertEqual(result, value)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
}
