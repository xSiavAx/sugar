import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateDeactivatedTC: SSMarkbaleCollectionCellHelperBaseTC {
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
