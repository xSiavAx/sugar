import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperUnmarkTC: XCTestCase {
    let testHelper = SSMarkbaleCollectionCellHelperTestHelper()
    var sut: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        sut = testHelper.cellHelper
        sut.setMarking(true)
        sut.setMarked(true)
    }
    
    func testMark() {
        sut.setMarked(false, animated: false)
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testMarkAnimated() {
        sut.setMarked(false, animated: true)
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
    
    func testMarkExplicitNonAnimated() {
        sut.setMarked(false, animated: true)
        
        testHelper.checkCell(sut, marking: true, marked: false)
    }
}
