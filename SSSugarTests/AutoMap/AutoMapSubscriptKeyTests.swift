/*
 
 Tests for AutoMap subscript(key:)
 
 [Done] getter
    [Done] key
        [Done] existing
        [Done] nonexistent
    [Done] empty AutoMap
 
 [Done] setter
    [Done] key
        [Done] existing
        [Done] nonexistent
    [Done] nil value
    [Done] empty AutoMap
 
 */

import XCTest
@testable import SSSugar

class AutoMapSubscriptKeyTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelperOld = AutoMapTestHelper()
    let testHelper = AutoMapTestHelper()
    
    func testGetter() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        let sut = AutoMap(map: map)
        
        XCTAssertEqual(sut[.evens], Item.evens.array)
        XCTAssertNil(sut[.new])
        testHelper.assertEqual(sut, map)
    }
    
    func testGetterEmptyAutoMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut[.evens])
        testHelper.assertEqual(sut, [:])
    }
    
    func testSetterExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens] = Item.evensNew.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensNew))
    }
    
    func testSetterNonexistentKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.odds] = Item.odds.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testSetterExistingKeyNilValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut[.evens] = nil
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .odds))
    }
    
    func testSetterNonexistentKeyNilValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        sut[.new] = nil
        testHelper.assertEqual(sut, map)
    }
    
    func testSetterEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        sut[.evens] = Item.evens.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens))
    }
    
    func testSetterEmptyAutoMapNilValue() {
        var sut = AutoMap<Item, [Int]>()
        
        sut[.evens] = nil
        testHelper.assertEqual(sut, [:])
    }
}
