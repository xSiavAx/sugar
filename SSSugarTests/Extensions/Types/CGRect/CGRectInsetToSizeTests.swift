import XCTest

class CGRectInsetToSizeTests: XCTestCase {
    func testSame() {
        checkInset(0, 0, 100, 50, 100, 50)
    }
    
    func testDecrease() {
        checkInset(0, 0, 100, 100, 50, 50)
    }
    
    func testIncrease() {
        checkInset(0, 0, 50, 50, 100, 100)
    }
    
    func testCross() {
        checkInset(0, 0, 100, 50, 50, 100)
    }
    
    func testToZero() {
        checkInset(0, 0, 100, 50, 0, 0)
    }
    
    func testMovedPosPos() {
        checkInset(50, 50, 100, 100, 50, 50)
    }
    
    func testMovedPosNeg() {
        checkInset(50, -50, 100, 100, 50, 50)
    }
    
    func testMovedNegNeg() {
        checkInset(-50, -50, 100, 100, 50, 50)
    }
    
    func testMovedNegPos() {
        checkInset(-50, 50, 100, 100, 50, 50)
    }

    func checkInset(_ x: CGFloat, _ y: CGFloat, _ w:CGFloat, _ h:CGFloat, _ tW:CGFloat, _ tH:CGFloat) {
        let source = CGRect(x:x, y:y, width:w, height:h)
        let toSize = CGSize(width: tW, height: tH)
        let expect = CGRect(center: source.center, size: toSize)
        let result = source.inset(toSize: toSize)
        
        XCTAssertEqual(result, expect)
    }
}
