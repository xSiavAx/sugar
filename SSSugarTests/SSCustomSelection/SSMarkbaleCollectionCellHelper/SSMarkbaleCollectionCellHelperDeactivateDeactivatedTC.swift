import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateDeactivatedTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.cellHelper
    }
    
    func testActivate() {
        sut.setMarking(false)
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        sut.setMarking(false, animated: false)
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testActivateAnimated() {
        sut.setMarking(false, animated: true)
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
}
