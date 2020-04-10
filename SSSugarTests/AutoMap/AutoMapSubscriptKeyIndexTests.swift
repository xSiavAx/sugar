/*
 Tests for subscript(key:index:) in AutoMap
 
 [Done] getter contained key contained index
 [Done] getter not contained key contained index
 [fatalError] getter not contained index
 [Done] getter empty AutoMap
 [Done] setter contained key setter contained index
 [fatalError] setter contained key setter not contained index
 [fatalError] setter not contained key
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
