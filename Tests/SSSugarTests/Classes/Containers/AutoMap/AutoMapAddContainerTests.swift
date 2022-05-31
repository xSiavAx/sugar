/*
 Tests for add(container:for:) method in AutoMap

 [Done] contained key
 [Done] not contained key
 [Done] empty AutoMap
 [Done] empty container contained key
 [Done] empty container not contained key
 [Done] empty container empty AutoMap
 */

import XCTest
@testable import SSSugarCore

class AutoMapAddContainerTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testContainedKey() {
        let map = testHelper.arrayMap(from: .evens)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.add(container: Item.odds.array, for: .evens))
        testHelper.assertEqual(sut, map)
    }
    
    func testNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.add(container: Item.odds.array, for: .odds))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertTrue(sut.add(container: Item.odds.array, for: .odds))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .odds))
    }
    
    func testEmptyContainerContainedKey() {
        let map = testHelper.arrayMap(from: .evens)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.add(container: [], for: .evens))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyContainerNotContainedKey() {
        let map = testHelper.arrayMap(from: .evens)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.add(container: [], for: .odds))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyContainerEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertFalse(sut.add(container: [], for: .odds))
        testHelper.assertEqual(sut, [Item : [Int]]())
    }
}
