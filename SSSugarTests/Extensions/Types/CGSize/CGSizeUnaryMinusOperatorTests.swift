/*
 Tests for unary minus operator in CGSize extension
 
 [width] options of the width for the size to which the operator is applied
    [plus] above zero
    [zero] equals zero
    [minus] less than zero
 [height] options of the height for the size to which the operator is applied
    [plus] above zero
    [zero] equals zero
    [minus] less than zero
 
 [Done] plus width + plus height
 [Done] plus width + zero height
 [Done] plus width + minus height
 [Done] zero width + plus height
 [Done] zero width + zero height
 [Done] zero width + minus height
 [Done] minus width + plus height
 [Done] minus width + zero height
 [Done] minus width + minus height
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
