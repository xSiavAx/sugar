/*

 Tests for AutoMap 
 
 [Done] key
    [Done] contained
    [Done] not contained
 [Done] contained value
 [Done] empty AutoMap
 [Done] ReplaceableCollection container
 
 */

import XCTest

@testable import SSSugar

class AutoMapAddTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testContainedKey() {
        var sut = AutoMap(map: testHelper.setMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.setMap(from: .evensAdd))
    }
    
    func testNotContainedKey() {
        var sut = AutoMap(map: testHelper.setMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .new))
        testHelper.assertEqual(sut, testHelper.setMap(from: .evens, .new))
    }
    
    func testWithContainedValue() {
        var sut = AutoMap(map: testHelper.setMap(from: .evens))
        
        XCTAssertFalse(sut.add(Item.evensFirstValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.setMap(from: .evens))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, Set<Int>>()
        
        XCTAssertTrue(sut.add(Item.addValue, for: .new))
        testHelper.assertEqual(sut, testHelper.setMap(from: .new))
    }
    
    func testContainedKeyReplaceableCollectionContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensAdd))
    }
    
    func testNotContainedKeyReplaceableCollectionContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.addValue, for: .new))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
    }
    
    func testContainedValueReplaceableCollectionContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(Item.evensSecondValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensDoubleSecond))
    }
    
    func testEmptyAutoMapReplaceableCollectionContainer() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertTrue(sut.add(Item.addValue, for: .new))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .new))
    }
}
