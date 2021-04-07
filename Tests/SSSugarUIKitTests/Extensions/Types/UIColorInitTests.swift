/*
 Tests for UIColor extension init(redV:greenV:blueV:alpha:), init(red:green:blue:)
 
 [Done] default red green blue
 [Done] default red
 [Done] default green
 [Done] default blue
 [Done] default alpha
 [Done] red
 [Done] green
 [Done] blue
 [Done] gray
 [Done] alpha
 */

import XCTest
@testable import SSSugarUIKIt

class UIColorInitTests: XCTestCase {
    func testDefaultRedGreenBlue() {
        XCTAssertEqual(UIColor(alpha: 1), UIColor(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func testDefaultRed() {
        XCTAssertEqual(UIColor(greenV: 255, blueV: 127, alpha: 1), UIColor(red: 0, green: 1, blue: 127 / 255, alpha: 1))
        XCTAssertEqual(UIColor(green: 0.75, blue: 0.5), UIColor(red: 0, green: 0.75, blue: 0.5, alpha: 1))
    }
    
    func testDefaultGreen() {
        XCTAssertEqual(UIColor(redV: 127, blueV: 255, alpha: 1), UIColor(red: 127 / 255, green: 0, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(red: 0.75, blue: 0.5), UIColor(red: 0.75, green: 0, blue: 0.5, alpha: 1))
    }
    
    func testDefaultBlue() {
        XCTAssertEqual(UIColor(redV: 255, greenV: 127, alpha: 1), UIColor(red: 1, green: 127 / 255, blue: 0, alpha: 1))
        XCTAssertEqual(UIColor(red: 0.75, green: 0.5), UIColor(red: 0.75, green: 0.5, blue: 0, alpha: 1))
    }
    
    func testDefaultAlpha() {
        XCTAssertEqual(UIColor(redV: 255, greenV: 255, blueV: 255), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(red: 0.75, green: 0.5, blue: 0.25), UIColor(red: 0.75, green: 0.5, blue: 0.25, alpha: 1))
    }
    
    func testRed() {
        XCTAssertEqual(UIColor(redV: 255), .red)
        XCTAssertEqual(UIColor(red: 1), .red)
    }
    
    func testGreen() {
        XCTAssertEqual(UIColor(greenV: 255), .green)
        XCTAssertEqual(UIColor(green: 1), .green)
    }
    
    func testBlue() {
        XCTAssertEqual(UIColor(blueV: 255), .blue)
        XCTAssertEqual(UIColor(blue: 1), .blue)
    }
    
    func testGray() {
        XCTAssertEqual(UIColor(redV: 255, greenV: 127, blueV: 63), UIColor(red: 1, green: 127 / 255, blue: 63 / 255, alpha: 1))
        XCTAssertEqual(UIColor(red: 1, green: 0.5, blue: 0.25), UIColor(red: 1, green: 0.5, blue: 0.25, alpha: 1))
    }
    
    func testAlpha() {
        XCTAssertEqual(UIColor(alpha: 0.5), UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
}
