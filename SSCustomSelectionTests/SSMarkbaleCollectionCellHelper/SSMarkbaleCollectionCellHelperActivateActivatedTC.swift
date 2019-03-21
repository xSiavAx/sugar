import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateActivatedTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        testableCellHelper.setMarking(true)
    }
    
    func testActivate() {
        testableCellHelper.setMarking(true)
        
        checkCell(marking: true, marked: false)
    }
    
    func testActivateExplicitNonAnimated() {
        testableCellHelper.setMarking(true, animated: false)
        
        checkCell(marking: true, marked: false)
    }
    
    func testActivateAnimated() {
        testableCellHelper.setMarking(true, animated: true)
        
        checkCell(marking: true, marked: false)
    }
}
