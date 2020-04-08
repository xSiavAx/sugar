/*
 Tests for unary minus operator in CGPoint extesnion
 
 [Done] x
    [Done] plus
    [Done] zero
    [Done] minus
 [Done] y
    [Done] plus
    [Done] zero
    [Done] minus
 */

import XCTest
@testable import SSSugar

class CGPointUnaryMinusTests: XCTestCase {
    func testPlusXPlusY() {
        XCTAssertEqual(-CGPoint(x: 324, y: 23), CGPoint(x: -324, y: -23))
    }
    
    func testPlusXZeroY() {
        XCTAssertEqual(-CGPoint(x: 86, y: 0), CGPoint(x: -86, y: 0))
    }
    
    func testPlusXMinusY() {
        XCTAssertEqual(-CGPoint(x: 7, y: -100), CGPoint(x: -7, y: 100))
    }
    
    func testZeroXPlusY() {
        XCTAssertEqual(-CGPoint(x: 0, y: 69), CGPoint(x: 0, y: -69))
    }
    
    func testZeroXZeroY() {
        XCTAssertEqual(-CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    }
    
    func testZeroXMinusY() {
        XCTAssertEqual(-CGPoint(x: 0, y: -982), CGPoint(x: 0, y: 982))
    }
    
    func testMinusXPlusY() {
        XCTAssertEqual(-CGPoint(x: -20, y: 55), CGPoint(x: 20, y: -55))
    }
    
    func testMinusXZeroY() {
        XCTAssertEqual(-CGPoint(x: -67, y: 0), CGPoint(x: 67, y: 0))
    }
    
    func testMinusXMinusY() {
        XCTAssertEqual(-CGPoint(x: -94, y: -72), CGPoint(x: 94, y: 72))
    }
}
