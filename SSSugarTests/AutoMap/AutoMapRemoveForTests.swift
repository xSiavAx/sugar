/*

 Tests for AutoMap remove(for:)
 
 [Done] key
    [Done] existing
    [Done] nonexistent
 [Done] empty AutoMap

*/

import XCTest
@testable import SSSugar

class AutoMapRemoveForTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
   
    func testExistingKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds, .fibonacci))
        
        XCTAssertEqual(sut.remove(for: .evens), Item.evens.array)
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .odds, .fibonacci))
    }
    
    func testNonexistentKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertNil(sut.remove(for: .fibonacci))
        testHelper.assertEqual(sut, testHelper.arrayMap(from: .evens, .odds))
    }
    
    func testEmptyAutoMap() {
        var sut = AutoMap<Item, [Int]>()
        
        XCTAssertNil(sut.remove(for: .evens))
        testHelper.assertEqual(sut, [:])
    }
}
