/*
 Tests for subscript(key:) in AutoMap
 
 [Done] getter
 [Done] getter empty AutoMap
 [Done] setter contained key
 [Done] setter not contained key
 [Done] setter contained key same container
 [Done] setter not contained key same container
 [Done] setter contained key nil value
 [Done] setter not contained key nil value
 [Done] setter empty AutoMap
 [Done] setter empty AutoMap nil value
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
    
    func testSetterContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.evens] = Item.evensNew.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensNew))
    }
    
    func testSetterNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut[.odds] = Item.odds.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testSetterContainedKeySameContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut[.evens] = Item.evens.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testSetterNotContainedKeySameContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .fibonacci))
        
        sut[.odds] = Item.evens.array
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .fibonacci, .oddsEvens))
    }
    
    func testSetterContainedKeyNilValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut[.evens] = nil
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .odds))
    }
    
    func testSetterNotContainedKeyNilValue() {
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
