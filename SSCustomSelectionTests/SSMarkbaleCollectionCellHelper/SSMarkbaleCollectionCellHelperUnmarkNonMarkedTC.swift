import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperUnmarkNonMarkedTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        cellHelper.setMarking(true)
    }
    
    func testMark() {
        cellHelper.setMarked(false, animated: false)
        
        checkCell(marking: true, marked: false)
    }
    
    func testMarkAnimated() {
        cellHelper.setMarked(false, animated: true)
        
        checkCell(marking: true, marked: false)
    }
    
    func testMarkExplicitNonAnimated() {
        cellHelper.setMarked(false, animated: true)
        
        checkCell(marking: true, marked: false)
    }
}
