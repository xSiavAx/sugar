import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperMarkNonActiveTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
    }
    
    func testMarkNonActive() {
        sut.setMarked(true, animated: false)
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testMarkNonActiveAnimated() {
        sut.setMarked(true, animated: true)
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testMarkNonActiveExplicitNonAnimated() {
        sut.setMarked(true, animated: false)
        testHelper.checkCell(sut, marking: false, marked: false)
    }
}
