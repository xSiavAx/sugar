import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateActivatedTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
        sut.setMarking(true)
    }
    
    func testActivate() {
        sut.setMarking(true)
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        sut.setMarking(true, animated: false)
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testActivateAnimated() {
        sut.setMarking(true, animated: true)
        testHelper.checkCell(sut, marking: true, marked: false)
    }
}
