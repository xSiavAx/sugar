import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        testableCellHelper.setMarking(true)
    }
    
    func testActivate() {
        testableCellHelper.setMarking(false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        testableCellHelper.setMarking(false, animated: false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testActivateAnimated() {
        testableCellHelper.setMarking(false, animated: true)
        
        checkCell(marking: false, marked: false)
    }
}
