/*
 
 Tests for unary minus operator in CGSize extension
 
 [Done] width
    [Done] plus
    [Done] zero
    [Done] minus
 [Done] height
    [Done] plus
    [Done] zero
    [Done] minus
 
 */

import XCTest
@testable import SSSugar

class CGSizeUnaryMinusOperatorTests: XCTestCase {
    
    var sut: CGSize!
    
    func testPlusWidthPlusHeight() {
        XCTAssertEqual(-CGSize(width: 345, height: 789), CGSize(width: -345, height: -789))
    }
    
    func testPlusWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: 53, height: 0), CGSize(width: -53, height: 0))
    }
    
    func testPlusWidthMinusHeight() {
        XCTAssertEqual(-CGSize(width: 49, height: -56), CGSize(width: -49, height: 56))
    }
    
    func testZeroWidthPlusHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: 890), CGSize(width: 0, height: -890))
    }
    
    func testZeroWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: 0), CGSize(width: 0, height: 0))
    }
    
    func testZeroWidthMinusHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: -3214), CGSize(width: 0, height: 3214))
    }
    
    func testMinusWidthPlusHeight() {
        XCTAssertEqual(-CGSize(width: -89, height: 14), CGSize(width: 89, height: -14))
    }
    
    func testMinusWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: -294, height: 0), CGSize(width: 294, height: 0))
    }
    
    func testMinusWidthMinusHeight() {
        XCTAssertEqual(-CGSize(width: -8, height: -637), CGSize(width: 8, height: 637))
    }
    
}
