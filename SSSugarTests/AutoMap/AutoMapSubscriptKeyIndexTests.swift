/*
 
 Tests for AutoMap subscript(key:index:)
 
 [Done] getter
    [Done] key
        [Done] contained
        [Done] not contained
    [Done] index
        [Done] contained
        [fatalError] not contained
    [Done] empty AutoMap
 
 [Done] setter
    [Done] key
        [Done] contained
        [fatalError] not contained
    [Done] index
        [Done] contained
        [fatalError] not contained
    [Done] nil value
 
 */

import XCTest
@testable import SSSugar

class AutoMapSubscriptKeyIndexTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testGetterContainedKey() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertEqual(sut[.evens, Item.evensContainedIndex], Item.evensContainedValue)
    }
    
    func testGetterNotContainedKey() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertNil(sut[.fibonacci, 1])
    }
    
    func testGetterEmptyAutoMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut[.evens, 0])
    }
    
    func testSetterContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensChangedIndex] = Item.evensChangedValue
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensChanged))
    }
    
    func testSetterNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))

        sut[.new, 0] = Item.addValue
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .new))
    }
    
    func testSetterNilValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensWithoutValueIndex] = nil
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutValue))
    }
}
