import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperMarkingTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.makeCellHelper()
        sut.setMarking(true)
    }
    
    func testMark() {
        sut.setMarked(true, animated: false)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: true)
    }
    
    func testMarkAnimated() {
        sut.setMarked(true, animated: true)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: true)
    }
    
    func testMarkExplicitNonAnimated() {
        sut.setMarked(true, animated: true)
        //TODO: [Review] Redurant
        
        testHelper.checkCell(sut, marking: true, marked: true)
    }
}
