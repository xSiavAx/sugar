/*

 Tests for AutoMap add(_:for:)
 
 [Done] existing key
 [Done] new key
 [Done] empty AutoMap
 [Done] InsertableCollection with contained value
 
 */

import XCTest

@testable import SSSugar

class AutoMapAddTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensAdd))
    }
    
    func testNewKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .new))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertTrue(sut.add(Item.addValue, for: .evens))
        testHelper.assertEqual(sut, [Item.evens : [Item.addValue]])
    }
    
    func testInsertableCollectionWithContainedValue() {
        var sut = AutoMap(map: testHelper.setMap(from: .evens))
        
        XCTAssertFalse(sut.add(Item.evensFirstContainedValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.setMap(from: .evens))
    }
}
