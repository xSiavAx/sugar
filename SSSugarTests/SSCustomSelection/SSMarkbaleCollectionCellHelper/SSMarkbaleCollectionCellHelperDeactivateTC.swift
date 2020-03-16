import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperDeactivateTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        cellHelper.setMarking(true)
    }
    
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
