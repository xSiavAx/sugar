import XCTest

class SSSugarExtensionSizeTests: XCTestCase {
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
    
    func checkUnited(lW:CGFloat, lH:CGFloat, rW:CGFloat, rH:CGFloat, eW:CGFloat, eH:CGFloat) {
        XCTAssertEqual(CGSize(width:lW, height:lH).united(with:CGSize(width:rW, height:rH)), CGSize(width:eW, height:eH))
    }
}
