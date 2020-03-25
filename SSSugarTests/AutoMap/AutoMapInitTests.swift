/*
 
 Tests for AutoMap init(), init(map:)
 
 [Done] init()
 [Done] init(map:)
    [Done] regular
    [Done] empty
    [Done] empty container
    [Done] with empty container
 
 */

import XCTest
@testable import SSSugar

class AutoMapInitTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testInit() {
        XCTAssertNotNil(AutoMap<Item, [Int]>())
    }
    
    func testInitMapRegular() {
        let map = testHelper.arrayMap(from: .evens)
        
        testHelper.assertEqual(AutoMap(map: map), map)
    }
    
    func testInitMapEmpty() {
        let emptyMap = [Item : [Int]]()
        
        testHelper.assertEqual(AutoMap(map: emptyMap), emptyMap)
    }
    
    func testInitMapEmptyContainer() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .empty))
        
        testHelper.assertEqual(sut, [:])
    }
    
    func testInitMapWithEmptyContainer() {
        let map = testHelper.setMap(from: .evens, .empty)
        let expectedMap = testHelper.setMap(from: .evens)
        
        testHelper.assertEqual(AutoMap(map: map), expectedMap)
    }
}
