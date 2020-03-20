import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateDeactivatedTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
    }
    
    func testActivate() {
        sut.setMarking(false)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        sut.setMarking(false, animated: false)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
    
    func testActivateAnimated() {
        sut.setMarking(false, animated: true)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: false, marked: false)
    }
}
