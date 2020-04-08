/*
 Tests for init(), init(map:) in AutoMap
 
 [Done] init()
 [Done] init(map:)
    [Done] regular
    [Done] empty
    [Done] empty container
    [Done] mixed container
 */

import XCTest
@testable import SSSugar

class AutoMapInitTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testInit() {
        testHelper.assertEqual(AutoMap<Item, [Int]>(), [:])
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
    
    func testInitMapMixedContainer() {
        let sut = AutoMap(map: testHelper.setMap(from: .evens, .empty))
        
        testHelper.assertEqual(sut, testHelper.setMap(from: .evens))
    }
}
