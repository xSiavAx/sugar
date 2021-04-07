import XCTest
@testable import SSSugarUIKit

class SSMarkbaleCollectionCellHelperMarkingTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
        sut.setMarking(true)
    }
    
    func testMark() {
        sut.setMarked(true, animated: false)
        testHelper.checkCell(sut, marking: true, marked: true)
    }
    
    func testMarkAnimated() {
        sut.setMarked(true, animated: true)
        testHelper.checkCell(sut, marking: true, marked: true)
    }
    
    func testMarkExplicitNonAnimated() {
        sut.setMarked(true, animated: true)
        testHelper.checkCell(sut, marking: true, marked: true)
    }
}
