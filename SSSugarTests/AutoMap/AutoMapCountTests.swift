/*
 
 Tests for AutoMap count
 
 [Done] regular
 [Done] empty AutoMap
 [Done] add
    [Done] value
    [Done] container
    [Done] empty container
    [Done] empty container nonexistent key
 [Done] remove
    [Done] value
    [Done] container
 
 */

import XCTest
@testable import SSSugar

class AutoMapCountTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()
    
    func testRegular() {
        let sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        XCTAssertEqual(sut.count, Item.evens.array.count + Item.odds.array.count)
    }
    
    func testEmptyAutoMap() {
        XCTAssertEqual(AutoMap<Item, [Int]>().count, 0)
    }
    
    func testAddValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(Item.addValue, for: .evens)
        XCTAssertEqual(sut.count, Item.evens.array.count + 1)
    }
    
    func testAddContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(container: Item.odds.array, for: .odds)
        XCTAssertEqual(sut.count, Item.evens.array.count + Item.odds.array.count)
    }
    
    func testAddEmptyContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(container: [], for: .evens)
        XCTAssertEqual(sut.count, Item.evens.array.count)
    }
    
    func testAddEmptyContainerNonExistentContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(container: [], for: .odds)
        XCTAssertEqual(sut.count, Item.evens.array.count)
    }
    
    func testRemoveValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.remove(Item.evensFirstContainedValue, for: .evens)
        XCTAssertEqual(sut.count, Item.evens.array.count + Item.odds.array.count - 1)
    }
    
    func testRemoveContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.remove(for: .evens)
        XCTAssertEqual(sut.count, Item.odds.array.count)
    }

}
