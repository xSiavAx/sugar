/*
 Tests for remove(for:at:) method in AutoMap
 
 [Done] contained key
 [Done] not contained key
 [Done] empty AutoMap
 [fatalError] not conteined index
 */

import XCTest
@testable import SSSugar

class AutoMapRemoveForAtTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.remove(for: .evens, at: Item.evensWithoutValueIndex), Item.evensWithoutValueValue)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutValue, .odds))
    }
    
    func testNotContainedKey() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertNil(sut.remove(for: .fibonacci, at: 2))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.remove(for: .evens, at: Item.evensWithoutValueIndex))
        testHelper.assertEqual(sut, [:])
    }
}
