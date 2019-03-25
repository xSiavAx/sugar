import XCTest

@testable import SSSugar

class SSSugarExtensionColorTests: XCTestCase {
    func testDefaultAll() {
        XCTAssertEqual(UIColor(alpha:1), UIColor(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func testDefaultRed() {
        XCTAssertEqual(UIColor(greenV: 255, blueV: 127), UIColor(red: 0, green: 1, blue: 127/255, alpha: 1))
    }
    
    func testDefaultGreen() {
        XCTAssertEqual(UIColor(redV: 127, blueV: 255), UIColor(red: 127/255, green: 0, blue: 1, alpha: 1))
    }
    
    func testDefaultBlue() {
        XCTAssertEqual(UIColor(redV: 255, greenV: 127), UIColor(red: 1, green: 127/255, blue: 0, alpha: 1))
    }
    
    func testRed() {
        XCTAssertEqual(UIColor(redV: 255), .red)
    }
    
    func testGreen() {
        XCTAssertEqual(UIColor(greenV: 255), .green)
    }
    
    func testBlue() {
        XCTAssertEqual(UIColor(blueV: 255), .blue)
    }
    
    func testGray() {
        XCTAssertEqual(UIColor(redV: 255, greenV: 127, blueV:63), UIColor(red: 1, green: 127/255, blue: 63/255, alpha: 1))
    }
    
    func testAlpha() {
        XCTAssertEqual(UIColor(alpha:0.5), UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
}
