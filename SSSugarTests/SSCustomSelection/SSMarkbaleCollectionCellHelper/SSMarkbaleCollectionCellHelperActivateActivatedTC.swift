import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateActivatedTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        cellHelper.setMarking(true)
    }
    
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
