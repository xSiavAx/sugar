/*
 Tests for subscript(key:index:) in AutoMap
 
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
    [fatalError] empty AutoMap
 */

import XCTest
@testable import SSSugar

class AutoMapSubscriptKeyIndexTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testGetterContainedKeyContainedIndex() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertEqual(sut[.evens, Item.evensContainedIndex], Item.evensContainedValue)
    }
    
    func testGetterNotContainedKeyContainedIndex() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertNil(sut[.fibonacci, 1])
    }
    
    func testGetterEmptyAutoMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut[.evens, 0])
    }
    
    func testSetterContainedKeyContainedIndex() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensChangedIndex] = Item.evensChangedValue
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensChanged))
    }
    
    func testSetterNilValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensWithoutValueIndex] = nil
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutValue))
    }
}
