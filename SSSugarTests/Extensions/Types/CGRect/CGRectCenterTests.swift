import XCTest

class CGRectCenterTests: XCTestCase {
    func testSquare() {
        checkCenter(0, 0, 100, 100, 50, 50)
    }
    
    func testWidthLarger() {
        checkCenter(0, 0, 100, 50, 50, 25)
    }
    
    func testHeightLarger() {
        checkCenter(0, 0, 50, 100, 25, 50)
    }
    
    func testEmpty() {
        checkCenter(0, 0, 0, 0, 0, 0)
    }
    
    func testEmptyMoved() {
        checkCenter(20, -50, 0, 0, 20, -50)
    }
    
    func testMovedPosPos() {
        checkCenter(20, 50, 100, 50, 70, 75)
    }
    
    func testMovedPosNeg() {
        checkCenter(20, -50, 100, 50, 70, -25)
    }
    
    func testMovedNegNeg() {
        checkCenter(-20, -60, 100, 50, 30, -35)
    }
    
    func testMovedNegPos() {
        checkCenter(-60, 50, 100, 50, -10, 75)
    }

    func checkCenter(_ x: CGFloat, _ y: CGFloat, _ w:CGFloat, _ h:CGFloat, _ eX:CGFloat, _ eY:CGFloat) {
        XCTAssertEqual(CGRect(x:x, y:y, width:w, height:h).center, CGPoint(x:eX, y:eY))
    }
}
