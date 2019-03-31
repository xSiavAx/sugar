import XCTest

class SSSugarExtensionCGRectInitCenterSize: XCTestCase {
    func testSquare() {
        doTest(50, 50, 100, 100, 0, 0)
    }
    
    func testWidthLarger() {
        doTest(50, 25, 100, 50, 0, 0)
    }
    
    func testHeightLarger() {
        doTest(25, 50, 50, 100, 0, 0)
    }
    
    func testEmpty() {
        doTest(0, 0, 0, 0, 0, 0)
    }
    
    func testEmptyMoved() {
        doTest(20, -50, 0, 0, 20, -50)
    }
    
    func testMovedPosPos() {
        doTest(70, 75, 100, 50, 20, 50)
    }
    
    func testMovedPosNeg() {
        doTest(70, -25, 100, 50, 20, -50)
    }
    
    func testMovedNegNeg() {
        doTest(30, -35, 100, 50, -20, -60)
    }
    
    func testMovedNegPos() {
        doTest(-10, 75, 100, 50, -60, 50)
    }

    func doTest(_ cX: CGFloat, _ cY: CGFloat, _ w: CGFloat, _ h: CGFloat, _ oX: CGFloat, _ oY: CGFloat) {
        let expected = CGRect(x: oX, y: oY, width: w, height: h)
        let result = CGRect(center: CGPoint(x: cX, y: cY), size: CGSize(width: w, height: h))
        
        XCTAssertEqual(result, expected)
    }
}
