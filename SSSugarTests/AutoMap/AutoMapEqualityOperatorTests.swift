/*
 Tests for == operator in AutoMap
 
 [Done] keys
    [Done] same
    [Done] added
    [Done] changed
 [Done] values
    [Done] same
    [Done] added
    [Done] changed
 [Done] empty AutoMap
 [Done] after changes
 */

import XCTest
@testable import SSSugar

class AutoMapEqualityOperatorTests: XCTestCase {
    typealias Item = AutoMapTestDefaultItem
    
    let testHelper = AutoMapTestHelper()

    func testSameKeysSameValues() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let rightSUT = leftSUT
        
        XCTAssertTrue(leftSUT == rightSUT)
    }
    
    func testSameKeyAddedValues() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let rightSUT = AutoMap(map: testHelper.arrayMap(from: .evensAdd, .odds))
        
        XCTAssertFalse(leftSUT == rightSUT)
    }
    
    func testSameKeysChangedValues() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let rightSUT = AutoMap(map: testHelper.arrayMap(from: .evensChanged, .odds))
        
        XCTAssertFalse(leftSUT == rightSUT)
    }
    
    func testAddedKeys() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let rightSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds, .fibonacci))
        
        XCTAssertFalse(leftSUT == rightSUT)
    }
    
    func testChangedKeys() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds))
        let rightSUT = AutoMap(map: testHelper.arrayMap(from: .fibonacci, .odds))
        
        XCTAssertFalse(leftSUT == rightSUT)
    }
    
    func testEmptyAutoMap() {
        let leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens))
        let rightSUT = AutoMap<Item, [Int]>()
        
        XCTAssertFalse(leftSUT == rightSUT)
    }
    
    func testAfterChanges() {
        var leftSUT = AutoMap(map: testHelper.arrayMap(from: .evens, .odds, .fibonacci))
        var rightSUT = AutoMap(map: testHelper.arrayMap(from: .evens))
        
        leftSUT.remove(for: .fibonacci)
        rightSUT.add(container: Item.odds.array, for: .odds)
        XCTAssertTrue(leftSUT == rightSUT)
    }
}
