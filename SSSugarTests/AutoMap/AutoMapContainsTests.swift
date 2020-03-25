/*
 
 Tests for AutoMap contains(_:for:)
 
 [Done] value
    [Done] contained
    [Done] not contained
 [Done] key
    [Done] existing
    [Done] nonexistent
 [Done] empty map
 
 */

import XCTest
@testable import SSSugar

class AutoMapContainsTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testExistingKey() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertTrue(sut.contains(Item.evensFirstContainedValue, for: .evens))
        XCTAssertFalse(sut.contains(Item.evensNotContainedValue, for: .evens))
    }
    
    func testNonexistentKey() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        XCTAssertFalse(sut.contains(Item.evensFirstContainedValue, for: .new))
        XCTAssertFalse(sut.contains(Item.evensNotContainedValue, for: .new))
    }
    
    func testEmptyMap() {
        let sut = AutoMap<Item, [Int]>()
        
        XCTAssertFalse(sut.contains(Item.evensFirstContainedValue, for: .evens))
        XCTAssertFalse(sut.contains(Item.evensNotContainedValue, for: .evens))
    }
}
