/*
 Tests for AutoMap.Iterator init(map:)

 [Done] regular container
 [Done] empty container
 [Done] mixed container
 [Done] empty map
 */

import XCTest
@testable import SSSugar

class AutoMapIteratorInitMapTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    typealias Iterator = AutoMap<Item, [Int]>.Iterator
    
    let testHelper = AutoMapTestHelper()
    
    func testRegularContainer() {
        XCTAssertNotNil(Iterator(map: testHelper.arrayMap(from: .evens, .odds)))
    }
    
    func testEmptyContainer() {
        XCTAssertNotNil(Iterator(map: testHelper.arrayMap(from: .empty)))
    }
    
    func testMixedContainer() {
        XCTAssertNotNil(Iterator(map: testHelper.arrayMap(from: .evens, .empty)))
    }
    
    func testEmptyMap() {
        XCTAssertNotNil(Iterator(map: [:]))
    }
}
