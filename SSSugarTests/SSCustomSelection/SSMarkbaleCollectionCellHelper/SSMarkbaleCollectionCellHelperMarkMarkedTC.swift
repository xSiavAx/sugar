import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperMarkMarkedTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
        sut.setMarking(true)
        sut.setMarked(true)
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
