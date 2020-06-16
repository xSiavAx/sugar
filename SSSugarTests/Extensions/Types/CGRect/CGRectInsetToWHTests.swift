import XCTest

class CGRectInsetToWHTests: XCTestCase {
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
    
    func testDefaultWidth() {
        checkInset(50, 50, 100, 100, nil, 50)
    }
    
    func testDefaultHeight() {
        checkInset(50, 50, 100, 100, 50, nil)
    }
    
    func checkInset(_ x: CGFloat, _ y: CGFloat, _ w:CGFloat, _ h:CGFloat, _ tW:CGFloat?, _ tH:CGFloat?) {
        let source = CGRect(x:x, y:y, width:w, height:h)
        var expected, result : CGRect!
        
        if let expectedW = tW, let extectedH = tH {
            result      = source.inset(toWidth:expectedW, toHeight:extectedH)
            expected    = CGRect(center: source.center, size: CGSize(width: expectedW, height: extectedH))
        } else if let expectedW = tW {
            result      = source.inset(toWidth:expectedW)
            expected    = CGRect(center: source.center, size: CGSize(width: expectedW, height: source.height))
        } else if let expectedH = tH {
            result      = source.inset(toHeight:expectedH)
            expected    = CGRect(center: source.center, size: CGSize(width: source.width, height: expectedH))
        }

        XCTAssertEqual(result, expected)
    }
}
