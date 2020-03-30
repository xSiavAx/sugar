/*
 
 Tests for Comparable extesion compare(_:)
 
 [Done] greater
 [Done] less
 [Done] equal
 
 */

import XCTest

class ExtensionComparableCompare: XCTestCase {
    
    let sut = 3
    
    func testGreater() {
        let other = 5
        
        XCTAssertEqual(sut.compare(other), .orderedAscending)
    }
    
    func testLess() {
        let other = 1
        
        XCTAssertEqual(sut.compare(other), .orderedDescending)
    }
    
    func testEqual() {
        let other = sut
        
        XCTAssertEqual(sut.compare(other), .orderedSame)
    }
}
