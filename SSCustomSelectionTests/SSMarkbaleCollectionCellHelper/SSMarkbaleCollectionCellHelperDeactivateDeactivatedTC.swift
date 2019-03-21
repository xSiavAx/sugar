import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateDeactivatedTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testActivate() {
        cellHelper.setMarking(false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        cellHelper.setMarking(false, animated: false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testActivateAnimated() {
        cellHelper.setMarking(false, animated: true)
        
        checkCell(marking: false, marked: false)
    }
}
