import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testActivate() {
        cellHelper.setMarking(true)
        
        checkCell(marking: true, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        cellHelper.setMarking(true, animated: false)
        
        checkCell(marking: true, marked: false)
    }
    
    func testActivateAnimated() {
        cellHelper.setMarking(true, animated: true)
        
        checkCell(marking: true, marked: false)
    }
}
