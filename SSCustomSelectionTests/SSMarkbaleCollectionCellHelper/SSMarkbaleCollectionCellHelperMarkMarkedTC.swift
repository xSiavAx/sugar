import XCTest

@testable import SSSugar

class SSMarkbaleCollectionCellHelperMarkMarkedTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        testableCellHelper.setMarking(true)
        testableCellHelper.setMarked(true)
    }
    
    func testMark() {
        testableCellHelper.setMarked(true, animated: false)
        
        checkCell(marking: true, marked: true)
    }
    
    func testMarkAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        checkCell(marking: true, marked: true)
    }
    
    func testMarkExplicitNonAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        checkCell(marking: true, marked: true)
    }
}
