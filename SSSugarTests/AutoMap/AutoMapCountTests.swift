/*
 Tests for count property in AutoMap
 
 [Done] regular
 [Done] empty AutoMap
 [Done] add value
 [Done] add value not contained key
 [Done] add container
 [Done] add empty container
 [Done] add empty container not contained key
 [Done] remove value
 [Done] remove container
 
 TODO: All this tests may be added to coresponding methods tests by adding 'count' checks.
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
    
    func testAddValueNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(Item.addValue, for: .new)
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
    
    func testAddEmptyContainerNotContainedKey() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        sut.add(container: [], for: .odds)
        XCTAssertEqual(sut.count, Item.evens.array.count)
    }
    
    func testRemoveValue() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.remove(Item.evensFirstValue, for: .evens)
        XCTAssertEqual(sut.count, Item.evens.array.count + Item.odds.array.count - 1)
    }
    
    func testRemoveContainer() {
        var sut = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        
        sut.remove(for: .evens)
        XCTAssertEqual(sut.count, Item.odds.array.count)
    }
}
