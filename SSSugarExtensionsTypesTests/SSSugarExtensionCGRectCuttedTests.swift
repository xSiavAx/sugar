import XCTest

class SSSugarExtensionCGRectCuttedTests: XCTestCase {
    func testLeft() {
        doTest(0, 0, 100, 100, 50, .minXEdge, 50, 0, 50, 100)
    }
    
    func testTop() {
        doTest(100, 100, 100, 100, 50, .minYEdge, 100, 150, 100, 50)
    }
    
    func testRight() {
        doTest(-50, -50, 100, 100, 50, .maxXEdge, -50, -50, 50, 100)
    }
    
    func testBottom() {
        doTest(-50, -50, 100, 100, 50, .maxYEdge, -50, -50, 100, 50)
    }
    
    func testZeroAmount() {
        doTest(0, 0, 100, 100, 0, .minXEdge, 0, 0, 100, 100)
    }
    
    func testLeftNegative() {
        doTest(-50, -50, 100, 100, 25, .minXEdge, -25, -50, 75, 100)
    }
    
    func testTopNegative() {
        doTest(-50, -50, 100, 100, 25, .minYEdge, -50, -25, 100, 75)
    }
    
    func testZeroResult() {
        doTest(0, 0, 100, 100, 100, .maxXEdge, 0, 0, 0, 100)
    }

    func doTest(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ a: CGFloat, _ s: CGRectEdge, _ eX: CGFloat, _ eY: CGFloat, _ eW: CGFloat, _ eH: CGFloat) {
        let source      = CGRect(x: x, y: y, width: w, height: h)
        let expected    = CGRect(x: eX, y: eY, width: eW, height: eH)
        let result      = source.cuted(amount: a, side: s)
        
        XCTAssertEqual(result, expected)
    }
}
