/*
 
 Tests for AutoMap remove(for:at:)
 
 [Done] key
    [Done] existing
    [Done] nonexistent
 [Done] empty AutoMap
 [fatalError] not conteined index
 
 */

import XCTest
@testable import SSSugar

class AutoMapRemoveForAtTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.remove(for: .evens, at: Item.evensWithoutElementIndex), Item.evensWithoutElementValue)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutElement, .odds))
    }
    
    func testNonexistentKey() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertNil(sut.remove(for: .fibonacci, at: 2))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.remove(for: .evens, at: Item.evensWithoutElementIndex))
        testHelper.assertEqual(sut, [:])
    }
}
