/*
 Tests for unary minus operator in CGPoint extension
 
 [x] options of the x coordinate for the point to which the operator is applied
    [positive] above zero
    [zero] equals zero
    [negative] less than zero
 [y] options of the y coordinate for the point to which the operator is applied
    [positive] above zero
    [zero] equals zero
    [negative] less than zero
 
 [Done] positive x positive y
 [Done] positive x zero     y
 [Done] positive x negative y
 [Done] zero     x positive y
 [Done] zero     x zero     y
 [Done] zero     x negative y
 [Done] negative x positive y
 [Done] negative x zero     y
 [Done] negative x negative y
 */

import XCTest
@testable import SSSugar

class CGPointUnaryMinusTests: XCTestCase {
    func testPositiveXPositiveY() {
        XCTAssertEqual(-CGPoint(x: 324, y: 23), CGPoint(x: -324, y: -23))
    }
    
    func testPositiveXZeroY() {
        XCTAssertEqual(-CGPoint(x: 86, y: 0), CGPoint(x: -86, y: 0))
    }
    
    func testPositiveXNegativeY() {
        XCTAssertEqual(-CGPoint(x: 7, y: -100), CGPoint(x: -7, y: 100))
    }
    
    func testZeroXPositiveY() {
        XCTAssertEqual(-CGPoint(x: 0, y: 69), CGPoint(x: 0, y: -69))
    }
    
    func testZeroXZeroY() {
        XCTAssertEqual(-CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    }
    
    func testZeroXNegativeY() {
        XCTAssertEqual(-CGPoint(x: 0, y: -982), CGPoint(x: 0, y: 982))
    }
    
    func testNegativeXPositiveY() {
        XCTAssertEqual(-CGPoint(x: -20, y: 55), CGPoint(x: 20, y: -55))
    }
    
    func testNegativeXZeroY() {
        XCTAssertEqual(-CGPoint(x: -67, y: 0), CGPoint(x: 67, y: 0))
    }
    
    func testNegativeXNegativeY() {
        XCTAssertEqual(-CGPoint(x: -94, y: -72), CGPoint(x: 94, y: 72))
    }
}
