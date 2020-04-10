/*
 Tests for update(_:for:at:) method in AutoMap
 
 [Done] contained key
 [Done] same value
 [fatalError] not contained key
 [fatalError] not contained index
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
