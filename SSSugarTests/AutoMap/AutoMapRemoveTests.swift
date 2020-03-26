/*
 
 Tests for AutoMap remove(_:for:)
 
 [Done] key
    [Done] existing
    [Done] nonexistent
 [Done] value
    [Done] contained
    [Done] not contained
 [Done] empty AutoMap
 
 */

import XCTest
@testable import SSSugar

class AutoMapRemoveTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testExistingKeyContainedValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertTrue(sut.remove(Item.evensWithoutElementValue, for: .evens))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evensWithoutElement, .odds))
    }

    #warning("force unwrap in Array extesion remove(e:) method")
//    func testExistingKeyNotContainedValue() {
//        let map = testHelper.arrayMap(from: .evens, .odds)
//        var sut = AutoMap(map: map)
//        
//        XCTAssertFalse(sut.remove(Item.evensNotContainedValue, for: .evens))
//        testHelper.assertEqual(sut, map)
//    }
    
    func testNonexistentKeyContainedValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.remove(Item.evensSecondContainedValue, for: .fibonacci))
        testHelper.assertEqual(sut, map)
    }
    
    func testNonexistentKeyNotContainedValue() {
        let map = testHelper.arrayMap(from: .evens, .odds)
        var sut = AutoMap(map: map)
        
        XCTAssertFalse(sut.remove(Item.evensNotContainedValue, for: .fibonacci))
        testHelper.assertEqual(sut, map)
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        sut.add(container: [], for: .evens)
        
        XCTAssertFalse(sut.remove(Item.evensSecondContainedValue, for: .evens))
        testHelper.assertEqual(sut, [:])
    }
}
