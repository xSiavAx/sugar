/*
 
 Tests for AutoMap subscript(key:index:)
 
 [Done] getter
    [Done] key
        [Done] existing
        [Done] nonexistent
    [Done] index
        [Done] existing
        [fatalError] nonexistent
    [Done] empty AutoMap
 
 [Done] setter
    [Done] key
        [Done] existing
        [fatalError] nonexistent
    [Done] index
        [Done] existing
        [fatalError] nonexistent
    [Done] nil value
 
 */

import XCTest
@testable import SSSugar

class AutoMapSubscriptKeyIndexTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testGetter() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertEqual(sut[.evens, 0], Item.evensFirstContainedValue)
        XCTAssertNil(sut[.fibonacci, 0])
    }
    
    func testGetterEmptyAutoMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut[.evens, 0])
    }
    
    func testSetter() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensChangedIndex] = Item.evensChangedValue
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensChanged))
    }
    
    func testSetterNilValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens, Item.evensWithoutElementIndex] = nil
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutElement))
    }
}
