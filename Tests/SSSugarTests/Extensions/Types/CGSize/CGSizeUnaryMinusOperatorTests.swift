/*
 Tests for unary minus operator in CGSize extension
 
 [width] options of the width for the size to which the operator is applied
    [positive] above zero
    [zero] equals zero
    [negative] less than zero
 [height] options of the height for the size to which the operator is applied
    [positive] above zero
    [zero] equals zero
    [negative] less than zero
 
 [Done] positive width + positive height
 [Done] positive width + zero height
 [Done] positive width + negative height
 [Done] zero width + positive height
 [Done] zero width + zero height
 [Done] zero width + negative height
 [Done] negative width + positive height
 [Done] negative width + zero height
 [Done] negative width + negative height
 */

import XCTest
@testable import SSSugarCore

class CGSizeUnaryMinusOperatorTests: XCTestCase {
    var sut: CGSize!
    
    func testPositiveWidthPositiveHeight() {
        XCTAssertEqual(-CGSize(width: 345, height: 789), CGSize(width: -345, height: -789))
    }
    
    func testPositiveWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: 53, height: 0), CGSize(width: -53, height: 0))
    }
    
    func testPositiveWidthNegativeHeight() {
        XCTAssertEqual(-CGSize(width: 49, height: -56), CGSize(width: -49, height: 56))
    }
    
    func testZeroWidthPositiveHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: 890), CGSize(width: 0, height: -890))
    }
    
    func testZeroWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: 0), CGSize(width: 0, height: 0))
    }
    
    func testZeroWidthNegativeHeight() {
        XCTAssertEqual(-CGSize(width: 0, height: -3214), CGSize(width: 0, height: 3214))
    }
    
    func testNegativeWidthPositiveHeight() {
        XCTAssertEqual(-CGSize(width: -89, height: 14), CGSize(width: 89, height: -14))
    }
    
    func testNegativeWidthZeroHeight() {
        XCTAssertEqual(-CGSize(width: -294, height: 0), CGSize(width: 294, height: 0))
    }
    
    func testNegativeWidthNegativeHeight() {
        XCTAssertEqual(-CGSize(width: -8, height: -637), CGSize(width: 8, height: 637))
    }
}
