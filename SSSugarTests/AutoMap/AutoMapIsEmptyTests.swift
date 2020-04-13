/*
 Tests for isEmpty property in AutoMap
 
 [Done] empty
 [Done] not empty
 [Done] remove container
 [Done] add container
 
 TODO: All this tests may be added to coresponding methods tests by adding 'isEmpty' checks.
 */

import XCTest
@testable import SSSugar

class AutoMapIsEmptyTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testEmpty() {
        XCTAssertTrue(AutoMap<Item, [Int]>().isEmpty)
    }
    
    func testNotEmpty() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testRemoveContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.remove(for: .evens)
        XCTAssertTrue(sut.isEmpty)
    }
    
    func testAddContainer() {
        var sut = AutoMap<Item, [Int]>()
        
        sut.add(container: Item.evens.array, for: .evens)
        XCTAssertFalse(sut.isEmpty)
    }
}
