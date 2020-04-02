import XCTest

class CGSizeUnitedIntersectedTests: XCTestCase {
    func testUnitedDocExample() {
        checkUnited(lW: 100, lH: 50, rW: 25, rH: 75, eW: 100, eH: 75)
    }
    
    func testUnitedSmallAndBig() {
        checkUnited(lW: 50, lH: 25, rW: 100, rH: 75, eW: 100, eH: 75)
    }
    
    func testUnitedBigAndSmall() {
        checkUnited(lW: 100, lH: 75, rW: 50, rH: 25, eW: 100, eH: 75)
    }
    
    func testUnitedEquals() {
        checkUnited(lW: 100, lH: 75, rW: 100, rH: 75, eW: 100, eH: 75)
    }
    
    func testUnitedCross() {
        checkUnited(lW: 100, lH: 75, rW: 75, rH: 100, eW: 100, eH: 100)
    }
    
    func testUnitedWithZero() {
        checkUnited(lW: 100, lH: 75, rW: 0, rH: 0, eW: 100, eH: 75)
    }
    
    func testUnitedBothZero() {
        checkUnited(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0)
    }
    
    func testIntersectedDocExample() {
        checkIntersected(lW: 100, lH: 50, rW: 25, rH: 75, eW: 25, eH: 50)
    }
    
    func testIntersectedSmallAndBig() {
        checkIntersected(lW: 50, lH: 25, rW: 100, rH: 75, eW: 50, eH: 25)
    }
    
    func testIntersectedBigAndSmall() {
        checkIntersected(lW: 100, lH: 75, rW: 50, rH: 25, eW: 50, eH: 25)
    }
    
    func testIntersectedEquals() {
        checkIntersected(lW: 100, lH: 75, rW: 100, rH: 75, eW: 100, eH: 75)
    }
    
    func testIntersectedCross() {
        checkIntersected(lW: 100, lH: 75, rW: 75, rH: 100, eW: 75, eH: 75)
    }
    
    func testIntersectedWithZero() {
        checkIntersected(lW: 100, lH: 75, rW: 0, rH: 0, eW: 0, eH: 0)
    }
    
    func testIntersectedBothZero() {
        checkIntersected(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0)
    }
    
    func checkUnited(lW:CGFloat, lH:CGFloat, rW:CGFloat, rH:CGFloat, eW:CGFloat, eH:CGFloat) {
        XCTAssertEqual(CGSize(width:lW, height:lH).united(with:CGSize(width:rW, height:rH)), CGSize(width:eW, height:eH))
    }
    
    func checkIntersected(lW:CGFloat, lH:CGFloat, rW:CGFloat, rH:CGFloat, eW:CGFloat, eH:CGFloat) {
        XCTAssertEqual(CGSize(width:lW, height:lH).intersected(with:CGSize(width:rW, height:rH)), CGSize(width:eW, height:eH))
    }
}
