import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
    }
    
    func testActivate() {
        sut.setMarking(true)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        sut.setMarking(true, animated: false)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testActivateAnimated() {
        sut.setMarking(true, animated: true)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
}
